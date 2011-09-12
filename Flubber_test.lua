require 'lubyk'
require 'Flubber'

local should = test.Suite("Flubber")


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


function makeFlubber(hue)
  local f = Flubber(-0.2, 100, 200, 10000, -0.1, hue)
  local v1, v2, v3, v4 = makeVertex()
  f:addVertex(v1)
  f:addVertex(v2)
  f:addVertex(v3)
  f:addVertex(v4)
  return f
end

app = mimas.Application()
win = mimas.Window()
win:setMouseTracking(true)
point_choisi = {}
is_dragging = false
mouse = {xCoord=0, yCoord=0}

flub  = makeFlubber(0.5)
flub2 = makeFlubber(0.9)

function win.click(x, y, type, btn, mod) --(x, y, type, btn, mod) --type: mimas.MousePress, MouseRelease, DoubleClick
  -- si la souris est enfoncee
  if type==mimas.MousePress then
    if mod == mimas.ShiftModifier then
      dragged_vertex = flub2:click(x, y)
    else
      dragged_vertex = flub:click(x,y)
    end
    dragged_vertex.dragged = true
  -- si la souris est relachee
  elseif type==mimas.MouseRelease then
    --le relachement a lieu pendant un drag, on remet a false le drag, et on reinitialise le point selectionne
    if dragged_vertex then
      dragged_vertex.dragged = false
      dragged_vertex = nil
    end
    win:update()
  end
end

function win.mouse(x, y)
  if dragged_vertex then
    dragged_vertex.position[1] = x
    dragged_vertex.position[2] = y
    win:update()
  end
end

function win.paint(p, w, h)
  
  
  --calcul des liens entre les points
  flub:update()
  flub:qtWoodstockDraw(p, 
    false, -- points
    false, -- force
    true, -- edges
    true,  -- shape
    false  -- bezier ctrl
  )
  
  flub2:update()
  flub2:qtDraw(p, 
    false, -- points
    false, -- force
    true, -- edges
    true,  -- shape
    false  -- bezier ctrl
  )

	win:update()
end


win:show()
app:exec()

--test.all()
