require 'Vertex'
require 'Segment'
require 'Vector'

--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Edge      = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
local insert       = table.insert
local remove       = table.remove
local Segment      = Segment
local Vertex       = Vertex
local Vector       = Vector
local ipairs       = ipairs
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
  --attribution des segments cibles et des vertex sources aux segments du lien
  self.a_segment.target_segment = self.b_segment
  self.a_segment.source_vertex  = self.a_vertex
  self.b_segment.target_segment = self.a_segment
  self.b_segment.source_vertex  = self.b_vertex
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
  
  --attribution des forces et calcul des composantes polaires
  self.a_segment.vector = v1
  self.a_segment.force = -f
  self.a_segment:computePolar()
  
  self.b_segment.vector = -v1
  self.b_segment.force = f
  self.b_segment:computePolar()
  
end --updateSegments]]