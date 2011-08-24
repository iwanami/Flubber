require 'lubyk'
require 'Edge'
require 'Segment'
require 'Vertex'

local Elasticity = -0.18
local StableDistance = 70
local Compression = -Elasticity * StableDistance^2

local should = test.Suite("Edge")

function makeEdges()
  local v1 = Vector{1, 0}
  local v2 = Vector{-2, 1}
  local vert1 = Vertex()
  vert1.position = v1
  local vert2 = Vertex()
  vert2.position = v2
  --local e1 = Edge:newFromVertices{v1, v2}
  local e1 = Edge{a_segment = Segment(), 
                  b_segment = Segment(),
                  a_vertex = vert1,
                  b_vertex = vert2}--]]
  return e1
end

function should.updateSegments()
  local e = makeEdges()
  e:updateSegments(Elasticity, Compression)
  assertValueEqual({264.06, -88.02}, e.a_segment.force, 0.00001)
  assertValueEqual({-264.06, 88.02}, e.b_segment.force, 0.00001)
end

test.all()