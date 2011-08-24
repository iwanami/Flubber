require 'lubyk'
require 'Segment'

local should = test.Suite("Segment")

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


function should.havePolar()
  local s = makeSegment()
  s:computeForce()
  assertEqual(math.sqrt(64+25), s.norm)
  assertEqual(math.atan2(-5, 8), s.theta)
end

test.all()