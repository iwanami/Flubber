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


--===================================================================================================================
--indique si le point se trouve sur, a l'exterieur ou dans le cercle circonscrit du triangle fourni en parametre
--remarques: - la fonction renvoie 1 si le point est a l'exterieur, 0 s'il se trouve dessus et -1 s'il est a
--             l'interieur
--===================================================================================================================
function onCircumcicle(self, triangle)
  local a = triangle[1].position
  local b = triangle[2].position
  local c = triangle[3].position
  local ab = b-a
  local ac = c-a
  --calcul des coordonnees du centre du cercle circonscrit
  --c'est long et merdique, mais c'est la resolution du systeme:
  --AO*BC = 0
  --CO*AB = 0
  --ou O est l'orthocentre. je vous laisse l'exercice de refaire le systeme :p
  local y = ((c[2]*ab[2] + (c[1]-b[1])*ab[1])*ac[1] - b[2]*ac[2]*ab[1])/(ac[1]*ab[2] - ac[2]*ab[1])
  local x = ((b[2]-y)*ac[2])/ac[1]+b[1]
  --creation du nouveau point
  local o = new{x, y}
  --calcul de la longueur du rayon du cercle circonscrit
  local rayon = (o-a):norm()
  --calcul de la distance entre l'orthocentre et le point
  local dist_po = (o-self):norm()
  
  if dist_po > rayon then return 1
  elseif dist_po == rayon then return 0
  else return -1
  end
  
end

--===================================================================================================================
--indique si le point se trouve sur, a l'exterieur ou dans le triangle fourni en parametre
--remarques: - la fonction renvoie 1 si le point est a l'exterieur, 0 s'il se trouve dessus et -1 s'il est a
--             l'interieur
--===================================================================================================================
function onTriangle(self, triangle)
  local v0 = triangle[3].position-triangle[1].position
  local v1 = triangle[2].position-triangle[1].position
  local v2 = self-triangle[1].position
  local dot00 = dot(v0, v0)
  local dot01 = dot(v0, v1)
  local dot02 = dot(v0, v2)
  local dot11 = dot(v1, v1)
  local dot12 = dot(v1, v2)
  
  --calcul des coefficients permettant de determiner la position du point par rapport au triangle
  local denom = dot00*dot11-dot01^2
  u = (dot11*dot02 - dot01*dot12)/denom
  v = (dot00*dot12 - dot01*dot12)/denom
  
  if (u > 0) and (v > 0) and (u+v <= 1) then
    return -1
  elseif (u == 0) or (v == 0) and (u+v <= 1) then
    return 0
  else
    return 1
  end
  
end

function segmentIntersects(a, b, ab, c, d, cd)
  
  local t1, t2
  
  local t2_denom = (cd[2]*ab[1] - cd[1]*ab[2])
  local t1_denom = ab[1]
  
  --print(t1_denom, t2_denom)
  
  if t1_denom ~= 0 and t_2denom ~= 0 then
    t2 = ((a[2]-c[2])*ab[1] + (c[1]-a[1])*ab[2])/t2_denom
    t1 = (c[1]-a[1] + t2*cd[1])/t1_denom
  else
    return false
  end

  --print('t1:', t1, 't2:', t2)

  if t1 > 0 and t2 > 0 and t1 < 1 and t2 < 1 then
    --print('prout')
    return true
  end
end


--===================================================================================================================
--effectue le produit scalaire des deux vecteurs
--===================================================================================================================
function dot(vector1, vector2)
  return vector1[1]*vector2[1]+vector1[2]*vector2[2]
end