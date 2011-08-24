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
--===================================================================================================================
local function new(vect)
  local self = vect or {0, 0}
  setmetatable(self, lib)
  return self
end

--appel du constructeur new par l'intermediaire du nom de classe
setmetatable(lib, {__call = function(lib, ...) return new(...) end})
lib.__index = lib
--===================================================================================================================
--additionne les deux vecteurs et renvoie le resultat
--===================================================================================================================
function add(self, b)
  return new{self[1]+b[1],
             self[2]+b[2],
  }
end

--===================================================================================================================
--soustrait les deux vecteurs et renvoie le resultat
--===================================================================================================================
function sub(self, b)
  return new{
    self[1]-b[1],
    self[2]-b[2]
  }
end

--===================================================================================================================
--multiplie le vecteur par la valeur fournie et renvoie le resultat
--===================================================================================================================
function mult(self, lambda)
  return new{self[1]*lambda,
             self[2]*lambda,
  }
end

--===================================================================================================================
--additionne les deux vecteurs et renvoie le resultat
--===================================================================================================================
function negate(self)
  return new{-self[1],
             -self[2],
  }
end

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
end

--===================================================================================================================
--calcule la norme d'un vecteur
--===================================================================================================================
function norm(self)
  return sqrt(self[1]^2+self[2]^2)
end        

--===================================================================================================================
--transforme un vecteur en ses coordonnees polaires: rho pour la norme, theta pour l'angle
--===================================================================================================================
function toPolar(self)
  local rho = self:norm()
  local theta = atan2(self[2],self[1])
  return rho, theta
end

--===================================================================================================================
--augmente le vecteur par celui passe en parametre 
--===================================================================================================================
function addToSelf(self, b)
  self[1] = self[1]+b[1]
  self[2] = self[2]+b[2]
end

--===================================================================================================================
--diminue le vecteur par celui passe en parametre
--===================================================================================================================
function subToSelf(self, b)
  self[1] = self[1]-b[1]
  self[2] = self[2]-b[2]
end

--===================================================================================================================
--multiplie le vecteur par celui passe en parametre
--===================================================================================================================
function multToSelf(self, lambda)
  self[1] = self[1]*lambda
  self[2] = self[2]*lambda
end

--===================================================================================================================
--inverse le signe des composantes du vecteur
--===================================================================================================================
function negateSelf(self)
  self[1] = -self[1]
  self[2] = -self[2]
end

function __tostring(self)
  return '('..self[1]..', '..self[2]..')'
end
