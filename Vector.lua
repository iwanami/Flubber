--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Vector    = lib
--copie locale des fonctions standard utilisees
local tan = math.tan
local setmetatable = setmetatable
--parametrage de l'environnement
setfenv(-1, lib)
--===================================================================================================================
--cree un nouvel objet Vector
--contient: - la valeur selon l'axe x
--          - la valeur selon l'axe y 
--remarques: - on peut utiliser Vector comme un point du plan en utilisant les composantes comme des coordonnes
--           - le vecteur est nul s'il n'est pas reseigne a la creation
--===================================================================================================================
function new(vect)
  local self = vect or {x = 0, y = 0}
  return setmetatable(self, lib)
end

--===================================================================================================================
--additionne les deux vecteurs et renvoie le resultat
--===================================================================================================================
function add(self, b)
  return new{x = self.x+b.x, y = self.y+b.y}
end

--===================================================================================================================
--soustrait les deux vecteurs et renvoie le resultat
--===================================================================================================================
function sub(b)
  return new{x = self.x-b.x, y = self.y-b.y}
end

--===================================================================================================================
--multiplie le vecteur par la valeur fournie et renvoie le resultat
--===================================================================================================================
function mult(lambda)
  return new{x = self.x*lambda, y = self.y*lambda}
end

--===================================================================================================================
--additionne les deux vecteurs et renvoie le resultat
--===================================================================================================================
function negate()
  return new{x = -self.x, y = -self.y}
end

--===================================================================================================================
--surcharge des operateurs +, - (binaire), *, - (unaire)
--===================================================================================================================
__add = add
__sub = sub
__mul = mult
__unm = negate

--===================================================================================================================
--calcule la norme d'un vecteur
--===================================================================================================================
function norm()
  return math.sqrt(self.x^2+self.y^2)
end        

--===================================================================================================================
--transforme un vecteur en ses coordonnees polaires: rho pour la norme, theta pour l'angle
--===================================================================================================================
function toPolar()
  local rho = self:norm()
  local theta = math.tan(self.y/self.x)
  return rho, theta
end

--===================================================================================================================
--augmente le vecteur par celui passe en parametre 
--===================================================================================================================
function addToSelf(b)
  self.x = self.x+b.x
  self.y = self.y+b.y
end

--===================================================================================================================
--diminue le vecteur par celui passe en parametre
--===================================================================================================================
function subToSelf(b)
  self.x = self.x-b.x
  self.y = self.y-b.y
end

--===================================================================================================================
--multiplie le vecteur par celui passe en parametre
--===================================================================================================================
function multToSelf(lambda)
  self.x = self.x*lambda
  self.y = self.y*lambda
end

--===================================================================================================================
--inverse le signe des composantes du vecteur
--===================================================================================================================
function negateSelf()
  self.x = -self.x
  self.y = -self.y
end



