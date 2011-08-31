require 'Vertex'
require 'Edge'

--creation de la classe 'anonyme'
local lib = {}
--nommage de la classe
Triangle  = lib
--copie locale des fonctions standard utilisees
local setmetatable = setmetatable
local insert = table.insert
--parametrage de l'environnement
setfenv(1, lib)

--===================================================================================================================
--cree un nouvel objet Triangle
--contient: - les trois Vertex sommets
--          - les trois Edges reliant les sommets
--remarques: - les arguments doivent etre passes par noms. s'il ne sont pas renseignes, des valeurs par defaut sont 
--             attribuees
--           - Le triangle est lui-meme la liste contenant les Vertex. il sont donc indices normalement en lua, avec
--             la correspondance 1->a, 2->b, 3->c
--===================================================================================================================
function new(opts)
  local opts = opts or {}
  local self = {ab_edge  = opts.ab_edge or Edge{a_vertex=opts.a_vertex, b_vertex=opts.b_vertex},
                ac_edge  = opts.ac_edge or Edge{a_vertex=opts.a_vertex, b_vertex=opts.c_vertex},
                bc_edge  = opts.bc_edge or Edge{a_vertex=opts.b_vertex, b_vertex=opts.c_vertex},}
  setmetatable(self, lib)
  insert(self, opts.a_vertex or Vertex())
  insert(self, opts.b_vertex or Vertex())
  insert(self, opts.c_vertex or Vertex())
  return self
end --new]]

--appel du constructeur new par l'intermediaire du nom de classe
setmetatable(lib, {__call = function(lib, ...) return new(...) end})
lib.__index = lib

--===================================================================================================================
--renvoie l'edge oppose au point fourni en parametre. renvoie nil si le point ne fait pas partie du triangle
--===================================================================================================================
function oppositeEdge(self, vertex)
  if vertex == self[1] then return bc_edge
  elseif vertex == self[2] then return ac_edge
  elseif vertex == self[3] then return ab_edge
  else return nil
end --oppositeEdge]]

--===================================================================================================================
--indique si le triangle fourni en parametre est un voisin. C'est a dire qu'il contient un seul point different 
--(il y a un Edge commun entre eux)
--===================================================================================================================
function isNeighbor(triangle)
  local count = 0
  for _, v in ipairs(triangle) do
    for i, _ in ipairs(self) do
      if v ~= self[i] then count = count + 1 end
    end
  end
  return count == 1
end --isNeighbor]]

