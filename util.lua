--===================================================================================================================
--insere l'objet dans la liste s'il n'y est pas encore
--===================================================================================================================
local remove = table.remove
local insert = table.insert
function insertIfNotExists(list, item)
  for _, s in ipairs(list) do
    if item == s then 
      return
    end
  end
  insert(list, item)
end --insertIfNotExists]]


--===================================================================================================================
--supprime l'objet de la liste s'il existe
--===================================================================================================================
function removeIfExists(list, item)
  for i, s in ipairs(list) do
    if item == s then 
      remove(list, i)
      break
    end
  end
end--removeIfExists]]