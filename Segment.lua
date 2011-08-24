require 'Vertex'
require 'Vector'

--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Segment    = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
local Vector = Vector
local Vertex = Vertex
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
--===================================================================================================================
local function new(seg)
  local self = seg or {source_index  = 0,
                       --source_vertex = Vertex()
                       target_index  = 0,
                       target_vertex = Vertex(),
                       norm          = 0,
                       theta         = 0,
                       force         = Vector(),}
  return setmetatable(self, lib)
end--new]]

--appel du constructeur new par l'intermediaire du nom de classe
setmetatable(lib, {__call = function(lib, ...) return new(...) end})
lib.__index = lib

--===================================================================================================================
--calcule la force representee par le segment
--===================================================================================================================
function computeForce(self)
  self.norm, self.theta = self.force:toPolar()
end--computeForce]]