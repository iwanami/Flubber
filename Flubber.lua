require 'Edge'
require 'Vertex'
require 'Vector'
require 'Segment'
require 'util'
require 'lubyk'

--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Flubber   = lib
--copie locale des fonctions standard utilisees
local setmetatable   = setmetatable
local ipairs         = ipairs
local insert         = table.insert
local remove         = table.remove
local Edge           = Edge
local Vector         = Vector
local Vertex         = Vertex
local worker         = worker
local removeIfExists = removeIfExists
local pi             = math.pi
local sin            = math.sin
local cos            = math.cos
local abs            = math.abs
local Path           = mimas.Path
local EmptyBrush     = mimas.EmptyBrush


--constantes de selection et de drag, servant a deplacer les vertex du flubber
local Selection_Dist = 15
local Drag_Dist = 10

--constante de couleur du flubber
local Hue = 0.5

--parametrage de l'environnement
setfenv(1, lib)

--===================================================================================================================
--cree un nouvel objet Flubber
--l'elasticite et la distance sont des parametres obligatoires, ainsi que glue et cut, qui sont les distances de
--creation et de destruction, respectivement, d'un lien (pas utilises si flub est renseigne, peuvent etre nil)
--contient: - une liste de noeuds (Vertex)
--          - une liste d'aretes (Edge)
--          - une matrice d'adjacence sommets-sommets
--          - un time stamp pour determiner le dernier temps utilise dans les calculs
--          - l'elasticite du flubber*
--          - la distance de stabilite entre deux noeuds du flubber*
--          - la compression du flubber, calculee a partir de l'elasticite et de la distance de stabilite
--          - La distance de creation de lien entre deux vertex (Glue)*
--          - La distance de destruction de lien entre deux vertex (Cut)*
--remarques: - la matrice est triangulaire superieure: les distances sont symetriques et la distance au noeud lui-meme
--             est nulle.
--           - les arguments doivent etre passes par noms. s'il ne sont pas renseignes, des valeurs par defaut sont 
--             attribuees
--           - les parametres marques d'un "*" dans la liste ci-dessus doivent etre renseignes a la creation
--===================================================================================================================
function new(elasticity, stable_distance, glue, cut, mu, hue, opts)
  Vertex.mu_frottement = mu or Mu_Frottement
  local opts = opts or {}
  local self = {vertex_list     = opts.vertex_list or {},
                edge_list       = opts.edge_list or {},
                edge_matrix     = opts.edge_matrix or {},
                segment_list    = opts.segment_list or {},
                last_time       = opts.last_time or nil,
                Elasticity      = elasticity,
                Stable_Distance = stable_distance,
                Compression     = -(stable_distance^2 * elasticity),
                Glue            = glue,
                Cut             = cut,
                hue             = hue or Hue}
  return setmetatable(self, lib)
end --new]]

--appel du constructeur new par l'intermediaire du nom de classe
setmetatable(lib, {__call = function(lib, ...) return new(...) end})
lib.__index = lib

--===================================================================================================================
--ajoute un vertex a la liste deja presente et augmente la matrice d'edges
--===================================================================================================================
function addVertex(self, vertex)
  insert(self.vertex_list, vertex)
  self.edge_matrix[#self.vertex_list] = {}
end --addVertex]]

--===================================================================================================================
--cree un vertex a partir de la position fournie en parametre et l'ajoute a la liste
--===================================================================================================================
function addVertexFromPosition(self, position)
  local v = Vertex{position      = position,
                   force         = Vector(),
                   speed         = Vector(),
                   }
  v:computeForce()
  self:addVertex(v)
  return v
end --addVertexFromPosition]]

--===================================================================================================================
--verifie si le segment fourni en parametre croise le segment entre les deux points
--===================================================================================================================
function doesCrossWithExistingEdge(self, av, bv, edge)
  local a = av.position
  local b = bv.position
  local ab = b-a
  
  for i, e in ipairs(self.edge_list) do
    if e ~= edge then
      local cv = e.a_vertex
      local dv = e.b_vertex
      --l'edge est traite seulement s'ils n'ont pas de sommet commun
      if not (cv == av or cv == bv or dv == av or dv == bv) then
        local c = cv.position
        local d = dv.position
        local cd = e.a_segment.vector
        if Vector.segmentIntersects(a, b, ab, c, d, cd) then
          return true
        end
      end
    end
  end
  return false
end --doesCrossWithExistingEdge]]

--===================================================================================================================
--verifie si l'edge fourni en parametre croise l'edge appelant
--===================================================================================================================
function doesCrossOtherEdge(self, edge)
  return doesCrossWithExistingEdge(self, edge.a_vertex, edge.b_vertex, edge)
end --doesCrossOtherEdge]]

--===================================================================================================================
--Met a jour la liste des Edges par la methode des distances
--===================================================================================================================
local function computeEdges(self)
  local vertex_list_size = #self.vertex_list
  --on verifie la distance entre chaque point de
  for i, vertex in ipairs(self.vertex_list) do
    local row = self.edge_matrix[i]
    for j = i+1, vertex_list_size do
      local other_vertex = self.vertex_list[j]
      local edge = row[j]
      --calcul du vecteur entre les deux points courants et de sa norme
      local vect = other_vertex.position-vertex.position
      local norm = vect:norm()
      
      --si la norme du vecteur est dans la portee de la distance de connection, on ajoute un nouveau lien a la table
      --le lien n'est pas cree s'il en croise un autre deja existant
      if not edge and norm <= self.Glue and not doesCrossWithExistingEdge(self, vertex, other_vertex) then
        edge = Edge{a_vertex = vertex, b_vertex = other_vertex}
        insert(self.edge_list, edge)
        insert(vertex, edge.a_segment)
        insert(other_vertex, edge.b_segment)
        insert(self.segment_list, edge.a_segment)
        insert(self.segment_list, edge.b_segment)
        row[j] = edge
        
      --si la norme est plus grande que le seuil de rupture, on supprime le lien
      --l'edge est supprime s'il coupe un autre deja existant
      elseif edge and (norm > self.Cut or doesCrossOtherEdge(self, edge)) then
        row[j] = nil
        removeIfExists(self.edge_list, edge)
        removeIfExists(vertex, edge.a_segment)
        removeIfExists(other_vertex, edge.b_segment)
        removeIfExists(self.segment_list, edge.a_segment)
        removeIfExists(self.segment_list, edge.b_segment)
        edge = nil
      end
      if edge then
        edge:updateSegments(self.Elasticity, self.Compression)
      end
    end
  end
end --computeEdges]]


--===================================================================================================================
--met a jour les forces appliquees aux vertex
--===================================================================================================================
local function computeForces(self)
  for i, v in ipairs(self.vertex_list) do
    v:computeForce()
  end
end --computeForces]]

--===================================================================================================================
--Deplace les Vertices en fonction des influences precedentes
--===================================================================================================================
local function moveVertices(self, time)
  if self.last_time then
    for _, v in ipairs(self.vertex_list) do
      --les calculs etant effectues en secondes, on transforme le temps machine (ms).
      v:move((time - self.last_time)/1000)
    end
  end
  self.last_time = time
end --moveVertices]]

--===================================================================================================================
--trie les segments de tous les vertex de la liste
--===================================================================================================================
local function sortAllSegments(self)
  for i, v in ipairs(self.vertex_list) do
    v:sortSegments(function(a,b) return a.theta > b.theta end)
  end
end --sortAllSegments]]

--===================================================================================================================
--determine les edges de la face infinie du graphe representant le flubber
--===================================================================================================================
local function tryShape(segment, mark)
  local current = segment
  local count = 0
  while true do
    current = current:nextSegment()
    if not current or current == segment then
      break
    else
      current.mark = mark
      count = count + 1
    end
  end
  return count
end --tryShape]]


--===================================================================================================================
--determine les edges de la face infinie du graphe representant le flubber. La fonction renvoie le segment de depart
--===================================================================================================================
local function computeOuterShape(self)
  sortAllSegments(self)
  local max_count = 0
  local result
  local mark = worker:now()
  for _, segment in ipairs(self.segment_list) do
    if segment.mark ~= mark then
      local count = tryShape(segment, mark)
      if count > max_count then
        max_count = count
        result = segment
      end
    end
  end
  return result
end --computeOuterShape]]


--===================================================================================================================
--met a jour les listes de Vertices et d'Edges
--===================================================================================================================
function update(self)
  computeEdges(self)
  local ct = worker:now()
  moveVertices(self, ct)
  computeForces(self)  
end --update]]

--===================================================================================================================
--cree le chemin de dessin des vertex (version QT)
--===================================================================================================================
function qtDrawPoints(self)
  local path = Path()
  --on cree le chemin des liens entre les points
  for i, vertex in ipairs(self.vertex_list) do
    path:addRect(vertex.position[1], vertex.position[2], 2, 2)
  end
  return path
end --qtDrawEdges]]

--===================================================================================================================
--cree le chemin de dessin des edges (version QT)
--===================================================================================================================
function qtDrawEdges(self)
  local path = Path()
  --on cree le chemin des liens entre les points
  for i, edge in ipairs(self.edge_list) do
    path:moveTo(edge.a_vertex.position[1], edge.a_vertex.position[2])
    path:lineTo(edge.b_vertex.position[1], edge.b_vertex.position[2])
  end
  return path
end --qtDrawEdges]]

--===================================================================================================================
--cree le chemin de dessin des forces s'appliquant sur chaque point (version QT)
--===================================================================================================================
function qtDrawForces(self)
  local path = Path()
  for i,vertex in ipairs(self.vertex_list) do
    --chemin des forces
    for j, seg in ipairs(vertex) do
      path:moveTo(vertex.position[1], vertex.position[2])
      path:lineTo(vertex.position[1]+seg.force[1], vertex.position[2]+seg.force[2])
    end
  end
  return path
end --qtDrawForces]]

--===================================================================================================================
--calcule et renvoie le point de controle de la courbe de bezier pour le point b (a est le point precedent)
--===================================================================================================================
function computeCtrlPoint(self, a, b)
  local a_t = a.theta
  local b_t = b.theta
  --uniformisation des angles. evite d'avoir des points de controle inverses
  if b_t < a_t then
    b_t = b_t + 2*pi
  end
  local theta = (b_t + a_t)/2
  if b_t - a_t > pi then
    theta = theta - pi/2
  else
    theta = theta + pi/2
  end
  --calcul effectif du point de controle
  local d = self.Stable_Distance * 0.5
  return Vector{d * cos(theta-pi/2), d * sin(theta-pi/2)}
end

--===================================================================================================================
--cree le chemin de dessin de la coque externe du flubber (version QT)
--===================================================================================================================
function qtDrawShape(self)
  local path  = Path()
  local ctrls = Path()
  --chemin de la coque du flubber
  local shape = computeOuterShape(self)
  --le if sert juste a eviter les problemes s'il n'y a pas de liens...
  if shape then
    local start_p
    local p1, p2, p3, p4
    p4 = shape
    while true do
      p1 = p2
      p2 = p3
      p3 = p4
      p4 = p4:nextSegment()
      if p2 then
        p3.ctrl = computeCtrlPoint(self, p2, p3)
      end
      if p1 then
        -- we can start drawing
        local p2_pos = p2.source_vertex.position
        local p3_pos = p3.source_vertex.position
        --sauvegarde du point de depart
        if not start_p then
          start_p = p2
          path:moveTo(p2_pos[1], p2_pos[2])
        --on est revenu au point de depart, on arrete de dessiner
        elseif p2 == start_p then
          break
        end
        -- ctrl
        ctrls:moveTo(p2_pos[1], p2_pos[2])
        ctrls:lineTo(p2_pos[1]+p2.ctrl[1], p2_pos[2]+p2.ctrl[2])
        -- curve
        path:cubicTo(
          p2_pos[1]+p2.ctrl[1], p2_pos[2]+p2.ctrl[2],
          p3_pos[1]-p3.ctrl[1], p3_pos[2]-p3.ctrl[2],
          p3_pos[1],            p3_pos[2])
      end
    end
  end
  return path, ctrls
end --qtDrawShape]]

--===================================================================================================================
--dessine le Flubber a partir des listes de Vertices et d'Edges sur la composante graphique fournie en parametre.
--le parametre withForces permet d'afficher les forces sur chaque Vertex, disponible pour des raisons de 
--debug/esthetique (version QT)
--===================================================================================================================
function qtDraw(self, p, with_points, with_forces, with_edges, with_shape, with_ctrls)
  local hue = self.hue
  --dessin des vertex
  if with_points then
    local points = qtDrawPoints(self)
    p:setPen(2, 0.1)
    p:drawPath(points)
  end
  --dessin des forces appliquees a chaque vertex
	if with_forces then
	  local forces = qtDrawForces(self)
  	p:setPen(2, 0.1)
  	p:drawPath(forces)
	end
	--dessin des edges
  if with_edges then
    local path = qtDrawEdges(self)
    p:setPen(0.5, hue, 0.5, 0.5)
    p:drawPath(path)
  end
  --dessin des vecteurs de controle des courbes de bezier
  if with_ctrls then
    p:setPen(0.9, hue)
    p:setBrush(EmptyBrush)
    p:drawPath(ctrls_path)
  end
  --dessin du contour du flubber (avec remplissage)
  if with_shape then
    local shape_path, ctrls_path = qtDrawShape(self)
    p:setPen(4, hue)
    p:setBrush(hue, 1, 1, 0.3)
    p:drawPath(shape_path)
  end
end --qtDraw]]

--===================================================================================================================
--dessine le Flubber a partir des listes de Vertices et d'Edges sur la composante graphique fournie en parametre.
--le parametre withForces permet d'afficher les forces sur chaque Vertex, disponible pour des raisons de 
--debug/esthetique (version QT)
--Cette version change la couleur du flubber a chaque appel
--===================================================================================================================
function qtWoodstockDraw(self, p, with_points, with_forces, with_edges, with_shape, with_ctrls)
  self.hue = (self.hue + (worker:now() / 20000)) % 1.0
  qtDraw(self, p, with_points, with_forces, with_edges, with_shape, with_ctrls)
end --qtWoodstockDraw]]

--===================================================================================================================
--calcul de la distance de manhattan entre le vecteur a et les coordonnees x et y
--===================================================================================================================
local function manhattanDist(a, x, y)
  return abs(x - a[1]) + abs(y - a[2])
end --manhattanDist]]

--===================================================================================================================
--lors d'un click sur l'ecran, un vertex est selectionne s'il est dans la distance de selection (calcule avec la
--methode de manhattan), sinon, un nouveau vertex est ajoute
--===================================================================================================================
function click(self, x, y)
  --verifie si un point est a proximite
  for i, vertex in ipairs(self.vertex_list) do
    if manhattanDist(vertex.position, x, y) < Selection_Dist then
      return vertex
    end
  end
  --si un point a ete choisi dans la boucle, on sauve ses coordonnees d'origine
  return self:addVertexFromPosition(Vector{x, y})
end --click]]