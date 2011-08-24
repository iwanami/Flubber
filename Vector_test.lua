require 'lubyk'
require 'Vector'

local should = test.Suite("Vector")

function makeVector()
  local v1 = Vector:new{x=1, y=2}
  local v2 = Vector:new{x=8, y=-5}
  local v3 = Vector:new()
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
  assertValueEqual({2, 4}, 2*v1)
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
  local v1 = makeVector()
  local r, t = v1:toPolar()
  assertEqual(math.sqrt(5), r)
  assertEqual(math.tan(2), t)
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

test.all()