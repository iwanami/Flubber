--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Vertex    = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
--parametrage de l'environnement
setfenv(-1, lib)


--===================================================================================================================
--cree un nouvel objet Vertex
--contient: - la position du vertex
--          - la force resultante sur le vertex
--          - la vitesse du vertex. utilise pour la force resultante
--          - une liste de segments
--remarques: le vertex lui-meme est la liste de segments. ils seront donc indices comme d'habitude dans lua
--===================================================================================================================
function new(vx)
  local self = vx or {position = Vector:new(),
                      force = Vector:new(),
                      speed = Vector:new(),}
                   
  return setmetatable(self, lib)
  
end

--===================================================================================================================
--trie les segments afin de pouvoir les parcourir correctement lors de la recherche de la forme du flubber
--===================================================================================================================
function sortSegments()
  
end

--===================================================================================================================
--deplace le vertex en fonction de la force qui s'applique dessus
--===================================================================================================================
function move(delta_t)
  
end

--===================================================================================================================
--calcule la force resultante s'appliquant sur le vertex
--===================================================================================================================
function computeForce()
  
end