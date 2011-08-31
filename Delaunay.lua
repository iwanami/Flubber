--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Delaunay  = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
--parametrage de l'environnement
setfenv(1, lib)

--===================================================================================================================
--cree un nouvel objet Delaunay
--contient: - la liste des points sur lesquels construire la triangulation
--          - la liste des triangles generes
--          - la liste des triangles voisins
--remarques: - les arguments doivent etre passes par noms. s'il ne sont pas renseignes, des valeurs par defaut sont 
--             attribuees
--===================================================================================================================
local function new(vect)
  local self = vect or {0, 0}
  setmetatable(self, lib)
  return self
end --new]]

--appel du constructeur new par l'intermediaire du nom de classe
setmetatable(lib, {__call = function(lib, ...) return new(...) end})
lib.__index = lib

--===================================================================================================================
--indique si le point se trouve sur, a l'exterieur ou dans le cercle circonscrit du triangle fourni en parametre
--remarques: - la fonction renvoie 1 si le point est a l'exterieur, 0 s'il se trouve dessus et -1 s'il est a
--             l'interieur
--===================================================================================================================