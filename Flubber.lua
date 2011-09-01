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
local setmetatable = setmetatable
local ipairs = ipairs
local insert = table.insert
local remove = table.remove
local Edge = Edge
local Vector = Vector
local Vertex = Vertex
local worker = worker
local print = print
local removeIfExists = removeIfExists
local pi = math.pi
local Path = mimas.Path
local flush = io.flush
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
--          - l'elasticite du flubber
--          - la distance de stabilite entre deux noeuds du flubber
--          - la compression du flubber, calculee a partir de l'elasticite et de la distance de stabilite
--remarques: - la matrice est triangulaire superieure: les distances sont symetriques et la distance au noeud lui-meme
--             est nulle.
--           - les arguments doivent etre passes par noms. s'il ne sont pas renseignes, des valeurs par defaut sont 
--             attribuees
--===================================================================================================================
function new(elasticity, stable_distance, glue, cut, mu, opts)
  Vertex.mu_frottement = mu or -0.2
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
                Cut             = cut,}
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
                   mu_frottement = -0.2,
                   mass          = 0.2,}
  v:computeForce()
  self:addVertex(v)
  return v
end --addVertexFromPosition]]

--===================================================================================================================
--verifie si les segments entre deux couples de vertex se croisent
--===================================================================================================================
function doesCrossWithExistingEdge(self, av, bv, edge)
  local a = av.position
  local b = bv.position
  local ab = b-a
  
  for i, e in ipairs(self.edge_list) do
    if e ~= edge then
      local cv = e.a_vertex
      local dv = e.b_vertex
      if cv == av or cv == bv or dv == av or dv == bv then
        -- skip
      else
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

function doesCrossOtherEdge(self, edge)
  return doesCrossWithExistingEdge(self, edge.a_vertex, edge.b_vertex, edge)
end --doesCrossOtherEdge]]

--===================================================================================================================
--Met a jour la liste des Edges par la methode des distances
--===================================================================================================================
local function computeEdges(self)
  local vertex_list_size = #self.vertex_list
  for i, vertex in ipairs(self.vertex_list) do
    local row = self.edge_matrix[i]
    for j = i+1, vertex_list_size do
      local other_vertex = self.vertex_list[j]
      local edge = row[j]
      --calcul du vecteur entre les deux points courants et de sa norme
      local vect = other_vertex.position-vertex.position
      local norm = vect:norm()
      --si la norme du vecteur est dans la portee de la distance de connection, on ajoute un nouveau lien a la table
      if  norm <= self.Glue and not edge and not doesCrossWithExistingEdge(self, vertex, other_vertex) then
        edge = Edge{a_vertex = vertex, b_vertex = other_vertex}
        insert(self.edge_list, edge)
        insert(vertex, edge.a_segment)
        insert(other_vertex, edge.b_segment)
        insert(self.segment_list, edge.a_segment)
        insert(self.segment_list, edge.b_segment)
        row[j] = edge
        --si la norme est plus grande que le seuil de rupture, on supprime le lien
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
--Met a jour la liste des Edges par une triangulation de delaunay
--===================================================================================================================
local function computeDelaunayEdges(self)
  
end --computeDelaunayEdges]]


--===================================================================================================================
--met a jour les forces
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
    for i, v in ipairs(self.vertex_list) do
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
end

--===================================================================================================================
--determine les edges de la face infinie du graphe representant le flubber
--===================================================================================================================
local function tryShape(segment, mark)
  local current = segment
  local count = 0
  while true do
    --print("tryShape:", current)
    current = current:nextSegment()
    if not current or current == segment then
      break
    else
      current.mark = mark
      count = count + 1
    end
  end
  --print(count)
  return count
end --computeShape]]


--===================================================================================================================
--determine les edges de la face infinie du graphe representant le flubber
--===================================================================================================================
local function computeOuterShape(self)
  sortAllSegments(self)
  --[[print('in computeOuterShape - list of all Vertices:')
  for i, v in ipairs(self.vertex_list) do
    print('vertex:',v , v.position)
    for j, s in ipairs(v) do
      print('target:', s.target_segment.source_vertex.position, 'angle:', s.theta/pi..' π')
      flush()
    end
  end--]]
  local max_count = 0
  local result
  local mark = worker:now()
  for i, segment in ipairs(self.segment_list) do
    if segment.mark ~= mark then
      local count = tryShape(segment, mark)
      if count > max_count then
        max_count = count
        result = segment
      end
    end
  end
  --print(result)
  return result
end


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
--dessine le Flubber a partir des listes de Vertices et d'Edges sur la composante graphique fournie en parametre.
--le parametre withForces permet d'afficher les forces sur chaque Vertex, disponible pour des raisons de 
--debug/esthetique
--===================================================================================================================
function draw(self, p, withForces, withEdges, withShape)
  
  local path = Path()
  local forces = Path()
  local shape_path = Path()
  
  --on cree le chemin des liens entre les points
  for i, edge in ipairs(self.edge_list) do
    path:moveTo(edge.a_vertex.position[1], edge.a_vertex.position[2])
    path:lineTo(edge.b_vertex.position[1], edge.b_vertex.position[2])
  end
  
  --on cree le chemin des points
  path:moveTo(self.vertex_list[1].position[1], self.vertex_list[1].position[2])
  for i,vertex in ipairs(self.vertex_list) do
    
    path:addRect(vertex.position[1], vertex.position[2], 2, 2)
    
    --chemin des forces
    if withForces then
      for j, seg in ipairs(vertex) do
        forces:moveTo(vertex.position[1], vertex.position[2])
        forces:lineTo(vertex.position[1]+seg.force[1], vertex.position[2]+seg.force[2])
      end
    end
  end
  
  --chemin de la coque du flubber
  local shape = computeOuterShape(self)
  --le if sert juste a eviter les problemes s'il n'y a pas de liens...
  if shape then
    local current = shape
    local pos = current.source_vertex.position
    shape_path:moveTo(pos[1], pos[2])
    while true do
      current = current:nextSegment()
      if not current then
        break
      else
        local pos = current.source_vertex.position
        shape_path:lineTo(pos[1], pos[2])
      end
      if current == shape then
        break
      end
    end
  end
  
	if withForces then
  	p:setPen(2, 0.1)
  	p:drawPath(forces)
	end
  if withEdges then
    p:setPen(0.5, 1, 0.5, 0.5)
    p:drawPath(path)
  end
  if withShape then
    p:setPen(4, 0.5)
    p:setBrush(0.5, 1, 1, 0.3)
    p:drawPath(shape_path)
  end
end --draw]]