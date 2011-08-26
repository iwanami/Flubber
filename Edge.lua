require 'Vertex'
require 'Segment'
require 'Vector'

--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Edge      = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
local insert = table.insert
local Segment = Segment
local Vertex = Vertex
local Vector = Vector
local Segment = Segment
local print = print
local ipairs = ipairs
--parametrage de l'environnement
setfenv(1, lib)

--===================================================================================================================
--cree un nouvel objet Edge (une arete entre deux noeuds)
--contient: - les deux vertex adjacents
--          - les segments de force associes aux sommets
--remarques: - les arguments doivent etre passes par noms. s'il ne sont pas renseignes, des valeurs par defaut sont 
--             attribuees
--===================================================================================================================
function new(opts)
  local opts = opts or {}
  local self = {a_segment = opts.a_segment or Segment(),
                b_segment = opts.b_segment or Segment(),
                a_vertex  = opts.a_vertex or Vertex(),
                b_vertex  = opts.b_vertex or Vertex(),}
  setmetatable(self, lib)
  return self
end --new]]

--appel du constructeur new par l'intermediaire du nom de classe
setmetatable(lib, {__call = function(lib, ...) return new(...) end})
lib.__index = lib


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
  self.a_segment:computeForce()
  
  local exists = false
  
  for i, s in ipairs(self.a_vertex) do
    if self.a_segment == s then 
      exists = true
      break
    end
  end
  
  if not exists then insert(self.a_vertex, self.a_segment) end
  
  self.b_segment.force = f
  self.b_segment.norm = f_norm
  self.b_segment:computeForce()
  
  exists = false
  
  for i, s in ipairs(self.a_vertex) do
    if self.b_segment == s then 
      exists = true
      break
    end
  end
  
  if not exists then insert(self.b_vertex, self.b_segment) end
end --updateSegments]]