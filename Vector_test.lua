require 'lubyk'
require 'Vector'

local should = test.Suite("Vector")

function makeVector()
  local v1 = Vector{1,  2}
  local v2 = Vector{8, -5}
  local v3 = Vector()
  return v1, v2, v3
end

function should.add()
  local v1, v2 = makeVector()
  assertValueEqual({9, -3}, v1+v2)
end

function should.sub()
  local v1, v2 = makeVector()
  assertValueEqual({-7, 7}, v1-v2)
end

function should.mult()
  local v1 = makeVector()
  assertValueEqual({2, 4}, v1*2)
end

function should.negate()
  local v1 = makeVector()
  assertValueEqual({-1, -2}, -v1)
end

function should.beNull()
  local v1, v2, v3 = makeVector()
  assertEqual(true, v3:isNull())
end

function should.beThisLong()
  local v1 = makeVector()
  assertEqual(math.sqrt(5), v1:norm())
end

function should.beInPolar()
  local tests = {
    [{1,0}]   = {1, 0},
    [{1,1}]   = {2, 1},
    [{0,1}]   = {1, 2},
    [{-1,1}]  = {2, 3},
    [{-1,0}]  = {1, 4},
    [{-1,-1}] = {2, -3},
    [{0,-1}]  = {1, -2},
    [{1,-1}]  = {2, -1},
  }
  for vect, res in pairs(tests) do
    local v1 = Vector(vect)
    local r, t = v1:toPolar()
    assertTrue(math.sqrt(res[1]) == r,  string.format("expected norm  (%f, %f) -> %f found %f", v1[1], v1[2], math.sqrt(res[1]), r))
    assertTrue(res[2] * math.pi/4 == t, string.format("expected angle (%f, %f) -> %f found %f", v1[1], v1[2], res[2] * math.pi/4, t))
  end
end

function should.addToSelf()
  local v1, v2 = makeVector()
  v1:addToSelf(v2)
  assertValueEqual({9, -3}, v1)
end

function should.subToSelf()
  local v1, v2 = makeVector()
  v1:subToSelf(v2)
  assertValueEqual({-7, 7}, v1)
end

function should.multToSelf()
  local v1, v2 = makeVector()
  v1:multToSelf(2)
  assertValueEqual({2, 4}, v1)
end

function should.negateSelf()
  local v1 = makeVector()
  v1:negateSelf()
  assertValueEqual({-1, -2}, v1)
end

function should.renderToString()
  local v1 = makeVector()
  v1:negateSelf()
  assertEqual('(-1, -2)', v1:__tostring())
end

test.all()