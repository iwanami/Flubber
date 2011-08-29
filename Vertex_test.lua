require 'lubyk'
require 'Vertex'

local should = test.Suite("Vertex")

function makeSegment()
  local s1 = Segment{source_index   = 0,
                     source_vertex  = Vertex(),
                     target_segment = {},
                     norm           = 0,
                     theta          = 0,
                     force          = Vector{-1, 0},
                    }
  
  local s2 = Segment{source_index   = 0,
                     source_vertex  = Vertex(),
                     target_segment = {},
                     norm           = 0,
                     theta          = 0,
                     force          = Vector{-1, -1},
                    }
                    
  local s3 = Segment{source_index   = 0,
                     source_vertex  = Vertex(),
                     target_segment = {},
                     norm           = 0,
                     theta          = 0,
                     force          = Vector{0, -1},
                    }
  s1:computeForce()
  s2:computeForce() 
  s3:computeForce() 
  return s1, s2, s3
end

function makeSegment2()
  local s1 = Segment{source_index   = 0,
                     source_vertex  = Vertex(),
                     target_segment = {},
                     norm           = 0,
                     theta          = 0,
                     force          = Vector{-1, 0},
                    }
  
  local s2 = Segment{source_index   = 0,
                     source_vertex  = Vertex(),
                     target_segment = {},
                     norm           = 0,
                     theta          = 0,
                     force          = Vector{-1, 1},
                    }
                    
  local s3 = Segment{source_index   = 0,
                     source_vertex  = Vertex(),
                     target_segment = {},
                     norm           = 0,
                     theta          = 0,
                     force          = Vector{0, 1},
                    }
  s1:computeForce()
  s2:computeForce() 
  s3:computeForce() 
  return s1, s2, s3
end

function makeVertex()
  local v1 = Vertex{position      = Vector{2, 2},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}
  local v2 = Vertex{position      = Vector{2, 2},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}
  local s1, s2, s3 = makeSegment()
  table.insert(v1, s1)
  table.insert(v1, s2)
  table.insert(v1, s3)
  local s4, s5, s6 = makeSegment2()
  table.insert(v2, s4)
  table.insert(v2, s5)
  table.insert(v2, s6)
  return v1, v2
end

--[[local v = makeVertex()

function should.move1()
  print("1:", v.speed[1], v.speed[2])
  v:move(1)
  print("2:", v.speed[1], v.speed[2])
  assertValueEqual({2, 2}, v.position)
  assertValueEqual({0, 0}, v.speed)
end

function should.computeThisForce1()
    print("3:", v.speed[1], v.speed[2])
  v:computeForce()
    print("4:", v.speed[1], v.speed[2])
  assertValueEqual({11, -2}, v.force)
end


--AAAAHHHHH!!!! faut inverser les deux dernieres methode pour que ca les prenne dans le bon ordre T_T
function should.computeThisForce2()
    print("7:", v.speed[1], v.speed[2])
  v:computeForce()
    print("8:", v.speed[1], v.speed[2])
  assertValueEqual({0, 0}, v.force)
end

function should.move2()
    print("5:", v.speed[1], v.speed[2])
  v:move(1)
    print("6:", v.speed[1], v.speed[2])
  assertValueEqual({29.5, -3}, v.position)
  assertValueEqual({55, -10}, v.speed)
end
--]]
function should.sort()
  local v1, v2 = makeVertex()
  print(v1)
  print(v2)
  for i, s in ipairs(v1) do
    print(s.theta)
  end
  for i, s in ipairs(v2) do
    print(s.theta)
  end
  v1:sortSegments(function(a,b) return a.theta > b.theta end)
  v2:sortSegments(function(a,b) return a.theta > b.theta end)
  print("sorted?")
  for i, s in ipairs(v1) do
    print(s.theta)
    --assertEqual(s.theta, result[i], 0.000001)
  end
  for i, s in ipairs(v2) do
    print(s.theta)
  end
end

test.all()