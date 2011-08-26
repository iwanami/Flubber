--===================================================================================================================
--insere l'objet dans la liste s'il n'y est pas encore
--===================================================================================================================
function insertIfNotExists(list, item)
  local exists = false
  for _, s in ipairs(list) do
    if item == s then 
      exists = true
      break
    end
  end
  if not exists then insert(list, item) end
end


--===================================================================================================================
--met a jour les segments de force de l'arete
--===================================================================================================================
function removeIfExists(list, item)
  for i, s in ipairs(list) do
    if item == s then 
      remove(list, i)
      break
    end
  end
end