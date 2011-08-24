require 'lubyk'
require 'Edge'

local should = test.Suite("Edge")

function makeEdges()
  local e1 = Edge:new{Segment:new{}}
end

function should.updateSegments()
  
end

test.all()