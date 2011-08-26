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
local function new(opts)
  local opts = opts or {}
  local self = {source_index  = opts.source_index or 0,
                --source_vertex = opts.source_vertex or Vertex()
                target_index  = opts.target_index or 0,
                target_vertex = opts.target_vertex or Vertex(),
                norm          = opts.norm or 0,
                theta         = opts.theta or 0,
                force         = opts.force or Vector(),}
  setmetatable(self, lib)
  return self
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