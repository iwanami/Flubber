require 'lubyk'
require 'Flubber'

local should = test.Suite("shape")

app = mimas.Application()
win = mimas.Window()
win:move(1,1)

local shape

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



flub = makeFlubber()
flub:update()
shape = flub:computeOuterShape()

--[[function should.haveShape()
  local flub = makeFlubber()
  flub:update()
  local shape = flub:computeOuterShape()
  
  for i, v in ipairs(shape) do
    print(v.position)
  end

end--]]

function win.paint(p, w, h)
  local path = mimas.Path()
  local current = shape
  local pos = current.source_vertex.position
  path:moveTo(pos[1], pos[2])
  while true do
    current = current:nextSegment()
    if not current or current == shape then
      break
    else
      local pos = current.source_vertex.position
      path:lineTo(pos[1], pos[2])
    end
  end
  
  p:setPen(4, 0.5)
  p:drawPath(path)
  io.flush()
end

win:show()
app:exec()