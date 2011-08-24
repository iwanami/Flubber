require 'Vertex'
require 'Segment'
require 'Vector'

--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Edge      = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
local Segment = Segment
local Vertex = Vertex
local Vector = Vector
local print = print
--parametrage de l'environnement
setfenv(1, lib)

--===================================================================================================================
--cree un nouvel objet Edge (une arete entre deux noeuds)
--contient: - les deux vertex adjacents
--          - les segments de force associes aux sommets
--===================================================================================================================
function new(edge)
  local self = edge or {a_segment = Segment(),
                        b_segment = Segment(),
                        a_vertex  = Vertex(),
                        b_vertex  = Vertex(),}
  setmetatable(self, lib)
  setmetatable(self.a_vertex,  {__mode = "v"})
  setmetatable(self.b_vertex,  {__mode = "v"})
  setmetatable(self.a_segment, {__mode = "v"})
  setmetatable(self.b_segment, {__mode = "v"})
  return self
end --new]]

--appel du constructeur new par l'intermediaire du nom de classe
setmetatable(lib, {__call = function(lib, ...) return new(...) end})
lib.__index = lib

--[[===================================================================================================================
--cree un nouvel objet Edge (une arete entre deux noeuds) a partir des deux vertex fournis en parametre. 
--les segments sont mis a jour pour correspondre aux vertices fournis
--===================================================================================================================
function newFromVertices(self, a, b)
  local e = new{a_segment = Segment(), 
                b_segment = Segment(),
                a_vertex = a,
                b_vertex = b,}
  --e:updateSegments()
  return e
end --newFromVertices]]

--===================================================================================================================
--met a jour les segments de force de l'arete
--===================================================================================================================
function updateSegments(self, elasticity, compression)
  --calcul du vecteur de l'edge
  local v1 = self.b_vertex.position - self.a_vertex.position
  --calcul de la longueur de l'edge
  local norm = v1:norm()
  --calcul de la force s'appliquant sur les vertices
  local f = v1*(elasticity + (compression / norm^2))
  local f_norm = f:norm()

  self.a_segment.force = -f
  self.a_segment.norm = f_norm
  
  self.b_segment.force = f
  self.b_segment.norm = f_norm
end --updateSegments]]