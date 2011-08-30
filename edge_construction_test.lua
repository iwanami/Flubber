require 'Flubber'
require 'lubyk'

local should = test.Suite("edge construction")


function makeVertex()
  local v1 = Vertex{position      = Vector{100, 300},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}
  local v2 = Vertex{position      = Vector{100, 100},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}
  local v3 = Vertex{position      = Vector{300, 100},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}
  local v4 = Vertex{position      = Vector{300, 300},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}

  return v1, v2, v3, v4
end


function makeFlubber(has_4_points)
  local f = Flubber(-0.2, 70, 100, 300)
  local v1, v2, v3, v4 = makeVertex()
  f:addVertex(v1)
  f:addVertex(v2)
  f:addVertex(v3)
  if has_4_points then
    f:addVertex(v4)
  end
  return f
end


--fonction testant 3 points -> 1 triangle -> 3 edges
function should.have3Edges()
  local flub = makeFlubber(false)
  flub:computeDelaunayEdges()
  print(flub.edge_list[1].a_vertex, flub.vertex_list[1])
  --(1) --> (2)
  assertTrue(flub.edge_list[1].a_vertex == flub.vertex_list[1], string.format("expected a_vertex -> %s found %s", flub.edge_list[1].a_vertex, flub.vertex_list[1]))
  assertTrue(flub.edge_list[1].b_vertex == flub.vertex_list[2], string.format("expected b_vertex -> %s found %s", flub.edge_list[1].a_vertex, flub.vertex_list[2]))
  --(1) --> (3)
  assertTrue(flub.edge_list[2].a_vertex == flub.vertex_list[1], string.format("expected a_vertex -> %s found %s", flub.edge_list[2].a_vertex, flub.vertex_list[1]))
  assertTrue(flub.edge_list[2].b_vertex == flub.vertex_list[3], string.format("expected b_vertex -> %s found %s", flub.edge_list[2].a_vertex, flub.vertex_list[3]))
  --(2) --> (3)
  assertTrue(flub.edge_list[3].a_vertex == flub.vertex_list[2], string.format("expected a_vertex -> %s found %s", flub.edge_list[3].a_vertex, flub.vertex_list[2]))
  assertTrue(flub.edge_list[3].b_vertex == flub.vertex_list[3], string.format("expected b_vertex -> %s found %s", flub.edge_list[3].a_vertex, flub.vertex_list[3]))
end

--fonction testant 4 points -> 2 triangles -> 5 edges
function should.have5Edges()
  local flub = makeFlubber(true)
  flub:computeDelaunayEdges()
  --(1) --> (2)
  assertTrue(flub.edge_list[1].a_vertex == flub.vertex_list[1], string.format("expected a_vertex -> %s found %s", flub.edge_list[1].a_vertex, flub.vertex_list[1]))
  assertTrue(flub.edge_list[1].b_vertex == flub.vertex_list[2], string.format("expected b_vertex -> %s found %s", flub.edge_list[1].a_vertex, flub.vertex_list[2]))
  --(1) --> (3)
  assertTrue(flub.edge_list[2].a_vertex == flub.vertex_list[1], string.format("expected a_vertex -> %s found %s", flub.edge_list[2].a_vertex, flub.vertex_list[1]))
  assertTrue(flub.edge_list[2].b_vertex == flub.vertex_list[3], string.format("expected b_vertex -> %s found %s", flub.edge_list[2].a_vertex, flub.vertex_list[3]))
  --(2) --> (3)
  assertTrue(flub.edge_list[3].a_vertex == flub.vertex_list[2], string.format("expected a_vertex -> %s found %s", flub.edge_list[3].a_vertex, flub.vertex_list[2]))
  assertTrue(flub.edge_list[3].b_vertex == flub.vertex_list[3], string.format("expected b_vertex -> %s found %s", flub.edge_list[3].a_vertex, flub.vertex_list[3]))
  --(1) --> (4)
  assertTrue(flub.edge_list[4].a_vertex == flub.vertex_list[1], string.format("expected a_vertex -> %s found %s", flub.edge_list[4].a_vertex, flub.vertex_list[1]))
  assertTrue(flub.edge_list[4].b_vertex == flub.vertex_list[4], string.format("expected b_vertex -> %s found %s", flub.edge_list[4].a_vertex, flub.vertex_list[4]))
  --(3) --> (4)
  assertTrue(flub.edge_list[5].a_vertex == flub.vertex_list[3], string.format("expected a_vertex -> %s found %s", flub.edge_list[5].a_vertex, flub.vertex_list[3]))
  assertTrue(flub.edge_list[5].b_vertex == flub.vertex_list[4], string.format("expected b_vertex -> %s found %s", flub.edge_list[5].a_vertex, flub.vertex_list[4]))
end

test.all()