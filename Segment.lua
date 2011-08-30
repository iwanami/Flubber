require 'Vertex'
require 'Vector'

--creation de la classe 'anonyme'
local lib = {type = 'Segment'}
--nommage de la classe
Segment    = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
local Vector = Vector
local Vertex = Vertex
local print = print
--parametrage de l'environnement
setfenv(1, lib)

--===================================================================================================================
--cree un nouvel objet Segment
--contient: - l'index de positionnement du segment dans le vertex source
--          - l'index de positionnement du prochain segment dans le vertex cible
--          - le vertex cible
--          - la norme de la force representee par le segment
--          - l'angle de la coordonnee polaire de la force representee par le segment
--          - la force representee par le segment
--remarques: - les arguments doivent etre passes par noms. s'il ne sont pas renseignes, des valeurs par defaut sont 
--             attribuees
--===================================================================================================================
local function new(vertex1, vertex2)
  local opts = opts or {}
  local self = {source_index   = opts.source_index or 0,
                source_vertex  = opts.source_vertex or Vertex(),
                target_segment = opts.target_segment or {},
                norm           = opts.norm or 0,
                theta          = opts.theta or 0,
                force          = opts.force or Vector(),}
  setmetatable(self, lib)
  return self
end--new]]

--appel du constructeur new par l'intermediaire du nom de classe
setmetatable(lib, {__call = function(lib, ...) return new(...) end})
lib.__index = lib

--===================================================================================================================
--calcule la force representee par le segment
--===================================================================================================================
function computePolar(self)
  self.norm, self.theta = self.vector:toPolar()
end--computeForce]]



function nextSegment(self)
  local target = self.target_segment
  local target_segment_count = #target.source_vertex
  if target_segment_count == 1 then
    return nil
  end
  
  local next_index = (target.source_index % target_segment_count) + 1
  --[[local next_index = target.source_index
  if next_index == 1 then
    next_index = target_segment_count
  else
    next_index = next_index-1
  end--]]
  print('nextSegment: s_index:', self.source_index, 'from', self.source_vertex, self.source_vertex.position, '---->', target.source_vertex, target.source_vertex.position, 'n_index', '['..next_index..']')
  return target.source_vertex[next_index]
end