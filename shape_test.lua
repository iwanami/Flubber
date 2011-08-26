require 'lubyk'
require 'Flubber'

local should = test.Suite("shape")

function makeVertex()
  local v1 = Vertex{position      = Vector{100, 150},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}
  local v2 = Vertex{position      = Vector{100, 100},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}
  local v3 = Vertex{position      = Vector{150, 100},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}
  local v4 = Vertex{position      = Vector{150, 150},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}

  return v1, v2, v3, v4
end


function makeFlubber()
  local f = Flubber(-0.18, 70, 100, 300)
  local v1, v2, v3, v4 = makeVertex()
  f:addVertex(v1)
  f:addVertex(v2)
  f:addVertex(v3)
  f:addVertex(v4)
  return f
end



function should.haveShape()
  local flub = makeFlubber()
  flub:update()
  local shape = flub:computeShape()
  
  for i, v in ipairs(shape) do
    print(v.position)
  end
  
end

test.all()