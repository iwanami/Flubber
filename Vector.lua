--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Vector    = lib
--copie locale des fonctions standard utilisees
local atan2        = math.atan2
local sqrt         = math.sqrt
local setmetatable = setmetatable
--parametrage de l'environnement
setfenv(1, lib)

--===================================================================================================================
--cree un nouvel objet Vector
--contient: - la valeur selon l'axe x avec comme cle 1
--          - la valeur selon l'axe y avec comme cle 2
--remarques: - on peut utiliser Vector comme un point du plan en utilisant les composantes comme des coordonnes
--           - le vecteur est nul s'il n'est pas reseigne a la creation
--           - les arguments doivent etre passes par noms. s'il ne sont pas renseignes, des valeurs par defaut sont 
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
--cree un nouvel objet Vector a partir des positions des Vertex fournis en parametre
--===================================================================================================================
function newFromVertices(v1, v2)
  return v2.position-v1.position
end --newFromVertices]]

--===================================================================================================================
--additionne les deux vecteurs et renvoie le resultat
--===================================================================================================================
function add(self, b)
  return new{self[1]+b[1],
             self[2]+b[2],
  }
end --add]]

--===================================================================================================================
--soustrait les deux vecteurs et renvoie le resultat
--===================================================================================================================
function sub(self, b)
  return new{
    self[1]-b[1],
    self[2]-b[2]
  }
end --sub]]

--===================================================================================================================
--multiplie le vecteur par la valeur fournie et renvoie le resultat
--===================================================================================================================
function mult(self, lambda)
  return new{self[1]*lambda,
             self[2]*lambda,
  }
end --mult]]

--===================================================================================================================
--additionne les deux vecteurs et renvoie le resultat
--===================================================================================================================
function negate(self)
  return new{-self[1],
             -self[2],
  }
end --negate]]

--===================================================================================================================
--surcharge des operateurs +, - (binaire), *, - (unaire) pour le calcul vectoriel
--===================================================================================================================
__add = add
__sub = sub
__mul = mult
__unm = negate

--===================================================================================================================
--indique si le vecteur est le vecteur nul (0, 0)
--===================================================================================================================
function isNull(self)
  return self[1] == 0 and self[1] == 0
end --isNull]]

--===================================================================================================================
--calcule la norme d'un vecteur
--===================================================================================================================
function norm(self)
  return sqrt(self[1]^2+self[2]^2)
end --norm]]    

--===================================================================================================================
--transforme un vecteur en ses coordonnees polaires: rho pour la norme, theta pour l'angle
--===================================================================================================================
function toPolar(self)
  local rho = self:norm()
  local theta = atan2(self[2],self[1])
  return rho, theta
end --toPolar]]

--===================================================================================================================
--augmente le vecteur par celui passe en parametre 
--===================================================================================================================
function addToSelf(self, b)
  self[1] = self[1]+b[1]
  self[2] = self[2]+b[2]
end --addToSelf]]

--===================================================================================================================
--diminue le vecteur par celui passe en parametre
--===================================================================================================================
function subToSelf(self, b)
  self[1] = self[1]-b[1]
  self[2] = self[2]-b[2]
end --subToSelf]]

--===================================================================================================================
--multiplie le vecteur par celui passe en parametre
--===================================================================================================================
function multToSelf(self, lambda)
  self[1] = self[1]*lambda
  self[2] = self[2]*lambda
end --multToSelf]]

--===================================================================================================================
--inverse le signe des composantes du vecteur
--===================================================================================================================
function negateSelf(self)
  self[1] = -self[1]
  self[2] = -self[2]
end --negateSelf]]

--===================================================================================================================
--renvoie un string contenant les valeurs d'un vecteur sous la forme "(x, y)"
--===================================================================================================================
function __tostring(self)
  return '('..self[1]..', '..self[2]..')'
end --__tostring]]
