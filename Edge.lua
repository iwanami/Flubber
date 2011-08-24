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
  setmetatable(self.a_vertex, {__mode = "v"})
  setmetatable(self.b_vertex, {__mode = "v"})
  setmetatable(self.a_segment, {__mode = "v"})
  setmetatable(self.b_segment, {__mode = "v"})
  return self
end

--===================================================================================================================
--met a jour les segments de force de l'arete
--===================================================================================================================
function updateSegments()
  
end