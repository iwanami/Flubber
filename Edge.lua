require 'Vertex'
require 'Segment'
require 'Vector'

--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Edge      = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
--parametrage de l'environnement
setfenv(-1, lib)

--===================================================================================================================
--cree un nouvel objet Edge (une arete entre deux noeuds)
--contient: - les deux vertex adjacents
--          - les segments de force associes aux sommets
--===================================================================================================================
function new(edge)
  local self = edge or {e.a_segment = Segment:new(),
                        e.b_segment = Segment:new(),
                        a_vertex    = Vertex:new(),
                        b_vertex    = Vertex:new(),}
  setmetatable(self, lib)
  setmetatable(self.a_vertex,  {__mode = "v"})
  setmetatable(self.b_vertex,  {__mode = "v"})
  setmetatable(self.a_segment, {__mode = "v"})
  setmetatable(self.b_segment, {__mode = "v"})
  return self
end

--===================================================================================================================
--cree un nouvel objet Edge (une arete entre deux noeuds) a partir des deux vertex fournis en parametre. 
--les segments sont mis a jour pour correspondre aux vertices fournis
--===================================================================================================================
function newFromVertices(a, b)
  local e = new{Segment:new(), Segment:new(), a, b}
  --e:updateSegments()
  return e
end

--===================================================================================================================
--met a jour les segments de force de l'arete
--===================================================================================================================
function updateSegments(elasticity, compression)
  --calcul du vecteur de l'edge
  local v1 = self.b_vertex.position - self.a_vertex.position
  --calcul de la longueur de l'edge
  local norm = v1:norm()
  --calcul de la force s'appliquant sur les vertices
  local f = v1*(elasticity + compression / (norm*norm))

  self.a_segment.force = f
  self.a_segment.norm = norm
  
  self.b_segment.force.x = -f
  self.b_segment.norm = norm
end