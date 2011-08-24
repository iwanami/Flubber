require 'Vector'

--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Vertex    = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
local ipairs       = ipairs
local Vector       = Vector
--parametrage de l'environnement
setfenv(1, lib)


--===================================================================================================================
--cree un nouvel objet Vertex
--contient: - la position du vertex
--          - la force resultante sur le vertex
--          - la vitesse du vertex. utilise pour la force resultante
--          - une liste de segments
--remarques: le vertex lui-meme est la liste de segments. ils seront donc indices comme d'habitude dans lua
--===================================================================================================================
local function new(vx)
  local self = vx or {position      = Vector(),
                      force         = Vector(),
                      speed         = Vector(),
                      mu_frottement = -0.2,
                      mass          = 0.2,}
  return setmetatable(self, lib)
end

--appel du constructeur new par l'intermediaire du nom de classe
setmetatable(lib, {__call = function(lib, ...) return new(...) end})
lib.__index = lib

--===================================================================================================================
--trie les segments afin de pouvoir les parcourir correctement lors de la recherche de la forme du flubber
--===================================================================================================================
function sortSegments(self)
  
end

--===================================================================================================================
--deplace le vertex en fonction de la force qui s'applique dessus
--===================================================================================================================
function move(self, delta_t)
  -- a = F/m
  local a = self.force*(1/self.mass)
  -- X = Xo + Vo * t + 1/2 a t^2
  self.position:addToSelf(self.speed*delta_t+(a*(0.5*delta_t^2)))
  -- V = Vo + a* t
  self.speed:addToSelf(a*delta_t)
end

--===================================================================================================================
--calcule la force resultante s'appliquant sur le vertex
--===================================================================================================================
function computeForce(self)
  local result = Vector()
  --vecteur force resultant
  for i, s in ipairs(self) do
    result:addToSelf(s.force)
  end
  -- ajout de la force de frottement
  result:addToSelf(self.speed*self.mu_frottement)
  self.force = result
end