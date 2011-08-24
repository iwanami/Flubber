--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Flubber   = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
--parametrage de l'environnement
setfenv(-1, lib)

--===================================================================================================================
--cree un nouvel objet Flubber
--l'elasticite et la distance sont des parametres obligatoires (pas utilises si flub est renseigne, peuvent etre nil)
--contient: - une liste de noeuds (Vertex)
--          - une liste d'aretes (Edge)
--          - une matrice d'adjacence sommets-sommets
--          - un time stamp pour determiner le dernier temps utilise dans les calculs
--          - l'elasticite du flubber
--          - la distance de stabilite entre deux noeuds du flubber
--          - la compression du flubber, calculee a partir de l'elasticite et de la distance de stabilite
--remarques: la matrice est triangulaire superieure: les distances sont symetriques et la distance au noeud lui-meme
--           est nulle
--===================================================================================================================
function new(elasticity, stable_distance, flub)
  local self = flub or {vertex_list = {},
                        edge_list   = {},
                        edge_matrix = {},
                        last_time = 0,
                        Elasticity = elasticity,
                        Stable_Distance = stable_distance,
                        Compression = -StableDistance^2 * Elasticity,}
  return setmetatable(self, lib)
end

--===================================================================================================================
--met a jour les listes de Vertices et d'Edges
--===================================================================================================================
function update(time)
  
end

--===================================================================================================================
--dessine le Flubber a partir des listes de Vertices et d'Edges
--===================================================================================================================
function draw()
  
end

--===================================================================================================================
--Met a jour la liste des Edges
--===================================================================================================================
local function computeEdges()
  
end

--===================================================================================================================
--met a jour les forces
--===================================================================================================================
local function computeForces()
  
end

--===================================================================================================================
--Deplace les Vertices en fonction des influences precedentes
--===================================================================================================================
local function moveVertices()
  
end

--===================================================================================================================
--determine les edges de la face infinie du graphe representant le flubber
--===================================================================================================================
local function computeShape()
  
end