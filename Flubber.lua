require 'Edge'
require 'Vertex'
require 'Vector'
require 'Segment'
require 'util'

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
function new(elasticity, stable_distance, glue, cut, opts)
  local opts = opts or {}
  local self = {vertex_list    = opts.vertex_list or {},
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

function addVertexFromPosition(self, position)
  local v = Vertex{position      = position,
                   force         = Vector(),
                   speed         = Vector(),
                   mu_frottement = -0.2,
                   mass          = 0.2,}
  v:computeForce()
  self:addVertex(v)
end



--===================================================================================================================
--dessine le Flubber a partir des listes de Vertices et d'Edges
--===================================================================================================================
function draw(self)
  
end --draw]]

--===================================================================================================================
--Met a jour la liste des Edges
--===================================================================================================================
function computeEdges(self)
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
      if  norm <= self.Glue and not edge then
        edge = Edge{a_vertex = vertex, b_vertex = other_vertex}
        insert(self.edge_list, edge)
        insert(vertex, edge.a_segment)
        insert(other_vertex, edge.b_segment)
        insert(self.segment_list, edge.a_segment)
        insert(self.segment_list, edge.b_segment)
        row[j] = edge
        --si la norme est plus grande que le seuil de rupture, on supprime le lien
      elseif norm > self.Cut and edge then
        row[j] = nil
        removeIfExists(self.edge_list, edge)
        removeIfExists(vertex, edge.a_segment)
        removeIfExists(other_vertex, edge.b_segment)
        edge = nil
      end
      if edge then
        edge:updateSegments(self.Elasticity, self.Compression)
      end
    end
  end
end --computeEdges]]


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
local function computeShape(self)
  sortAllSegments(self)
  local shape = {}
  local current_seg = self.segment_list[1]
  while current_seg ~= self.segment_list[1] do
    local target = current_seg.target_segment
    insert(shape, target.source_vertex)
    local next_index = (target.source_index+1)%#target.source_vertex
    current_seg = target.source_vertex[next_index]
  end
  return shape
end --computeShape]]


--===================================================================================================================
--met a jour les listes de Vertices et d'Edges
--===================================================================================================================
function update(self)
  
  computeEdges(self)
  local ct = worker:now()
  moveVertices(self, ct)
  computeForces(self)
  
end --update]]