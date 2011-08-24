require 'Vertex'
require 'Vector'

--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Segment    = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
--parametrage de l'environnement
setfenv(-1, lib)

--===================================================================================================================
--cree un nouvel objet Segment
--contient: - l'index de positionnement du segment dans le vertex source
--          - l'index de positionnement du prochain segment dans le vertex cible
--          - le vertex cible
--          - la norme de la force representee par le segment
--          - l'angle de la coordonnee polaire de la force representee par le segment
--          - la force representee par le segment
--===================================================================================================================
function new(seg)
  local self = seg or {source_index  = 0,
                       --source_vertex = Vertex:new()
                       target_index  = 0,
                       target_vertex = Vertex:new(),
                       norm          = 0,
                       theta         = 0,
                       force         = Vector:new(),}
  return setmetatable(self, lib)
end

--===================================================================================================================
--calcule la force representee par le segment
--===================================================================================================================
function computeForce()
  self.norm, self.theta = self.force:toPolar()
end