require 'lubyk'
require 'Vertex'

local should = test.Suite("Vertex")

function makeSegment()
  local s1 = Segment{source_index  = 0,
                    --source_vertex = Vertex()
                    target_index  = 0,
                    target_vertex = Vertex(),
                    norm          = 0,
                    theta         = 0,
                    force         = Vector{8, -5},}
  local s2 = Segment{source_index  = 0,
                    --source_vertex = Vertex()
                    target_index  = 0,
                    target_vertex = Vertex(),
                    norm          = 0,
                    theta         = 0,
                    force         = Vector{3, 2},}
  local s3 = Segment{source_index  = 0,
                    --source_vertex = Vertex()
                    target_index  = 0,
                    target_vertex = Vertex(),
                    norm          = 0,
                    theta         = 0,
                    force         = Vector{0, 1},}
                    
  return s1, s2, s3
end

function makeVertex()
  local v1 = Vertex{position      = Vector{2, 2},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}
  local s1, s2, s3 = makeSegment()
  table.insert(v1, s1)
  table.insert(v1, s2)
  table.insert(v1, s3)
  return v1
end

local v = makeVertex()

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


test.all()