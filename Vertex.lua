require 'Vector'

--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Vertex    = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
local ipairs       = ipairs
local Vector       = Vector
local print = print
local pi = math.pi
--parametrage de l'environnement
setfenv(1, lib)

local v_count = 0

--===================================================================================================================
--cree un nouvel objet Vertex
--contient: - la position du vertex
--          - la force resultante sur le vertex
--          - la vitesse du vertex. utilise pour la force resultante
--          - une liste de segments
--remarques: - le vertex lui-meme est la liste de segments. ils seront donc indices comme d'habitude dans lua
--           - les arguments doivent etre passes par noms. s'il ne sont pas renseignes, des valeurs par defaut sont 
--             attribuees
--===================================================================================================================
local function new(opts)
  local opts = opts or {}
  v_count = v_count+1
  local self = {position      = opts.position or Vector(),
                force         = opts.force or Vector(),
                speed         = opts.speed or Vector(),
                mu_frottement = opts.mu_frottement or -0.2,
                mass          = opts.mass or 0.2,
                name          = v_count,}
  return setmetatable(self, lib)
end --new]]

--appel du constructeur new par l'intermediaire du nom de classe
setmetatable(lib, {__call = function(lib, ...) return new(...) end})
lib.__index = lib

--===================================================================================================================
--trie les segments afin de pouvoir les parcourir correctement lors de la recherche de la forme du flubber
--===================================================================================================================
function sortSegments(self, condition)
  --print('sort', self)
  local n = #self
  local new_n
  repeat
    new_n = 0
    for i = 1, n-1 do
      if condition(self[i], self[i+1]) then
        self[i], self[i+1] = self[i+1], self[i]
        new_n = i+1
      end
    end
    n = new_n
  until n < 1
    
  for i, segment in ipairs(self) do
    --[[print(
      'in sort:', i, segment.source_vertex, segment.source_vertex.position, 
      segment.vector, segment.theta/pi, 
      segment.target_segment.source_vertex)--]]
    segment.source_index = i
  end
end --sortSegments]]

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
end --move]]

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
end --computeForce]]

--===================================================================================================================
--renvoie un string contenant le nom d'un vertex
--===================================================================================================================
function __tostring(self)
  return '('..self.name..')'
end --__tostring]]