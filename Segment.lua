require 'Vertex'
require 'Vector'

--creation de la classe 'anonyme'
local lib = {type = 'Segment'}
--nommage de la classe
Segment    = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
local Vector       = Vector
local Vertex       = Vertex
--parametrage de l'environnement
setfenv(1, lib)

--===================================================================================================================
--cree un nouvel objet Segment
--contient: - l'index de positionnement du segment dans le vertex source
--          - le vertex source
--          - le segment cible
--          - la norme de la force representee par le segment
--          - l'angle de la coordonnee polaire de la force representee par le segment
--          - la force representee par le segment
--remarques: - les arguments doivent etre passes par noms. s'il ne sont pas renseignes, des valeurs par defaut sont 
--             attribuees
--===================================================================================================================
local function new(opts)
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
end--computePolar]]


--===================================================================================================================
--renvoie le segment "a droite" (sens anti-horaire) sur un vertex. permet de parcourir le contour d'une forme
--===================================================================================================================
function nextSegment(self)
  local target = self.target_segment
  --si le vertex n'a qu'un seul lien, on le renvoie directement
  local target_segment_count = #target.source_vertex
  if target_segment_count == 1 then
    return target
  end
  
  local next_index = (target.source_index % target_segment_count) + 1
  return target.source_vertex[next_index]
end --nextSegment]]