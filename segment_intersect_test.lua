require 'lubyk'
require 'Vector'

local should = test.Suite("shape")

local segmentIntersects = Vector.segmentIntersects

local function testIntersect(a, b, c, d, intersect)
  a = Vector(a)
  b = Vector(b)
  c = Vector(c)
  d = Vector(d)
  local msg = string.format('a: %s, b: %s, c: %s, d: %s (%s)',
    a:__tostring(),
    b:__tostring(),
    c:__tostring(),
    d:__tostring(),
    intersect and 'true' or 'false'
  )
  if intersect then
    assertTrue(    segmentIntersects(a, b, b-a, c, d, d-c), msg)
  else
    assertTrue(not segmentIntersects(a, b, b-a, c, d, d-c), msg)
  end
end

function should.intersect1()
  testIntersect({0,0}, {1,1}, {1,0}, {0,1}, true)
end

function should.intersect2()
  testIntersect({0,0}, {2,2}, {1,1.5}, {3,1.5}, true)
end

function should.notIntersectShortAndLong()
  testIntersect({0,0}, {1,1}, {2,0}, {0,3}, false)
end

function should.notIntersectLongAndShort()
  testIntersect({2,0}, {0,3}, {0,0}, {1,1}, false)
end

function should.notIntersectOnSharedPosition()
  testIntersect({0,0}, {1,1}, {0,0}, {0,1}, false)
end

test.all()