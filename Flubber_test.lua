require 'lubyk'
require 'Flubber'

local White = mimas.colors.White


function makeVertex()
  local v1 = Vertex{position      = Vector{100, 200},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}
  local v2 = Vertex{position      = Vector{100, 100},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}
  local v3 = Vertex{position      = Vector{200, 100},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}
  local v4 = Vertex{position      = Vector{200, 200},
                    force         = Vector(),
                    speed         = Vector(),
                    mu_frottement = -0.2,
                    mass          = 0.2,}

  return v1, v2, v3, v4
end


function makeFlubber(hue)
  local f = Flubber(-0.2, --elasticity
                    100, --stable distance
                    -0.05, --coefficient de frottement
                    hue) --couleur
  local v1, v2, v3, v4 = makeVertex()
  f:addVertex(v1)
  f:addVertex(v2)
  f:addVertex(v3)
  f:addVertex(v4)
  return f
end

function makeFlubberWithRandomPoints(number)
    local f = Flubber(-0.2, 200, -0.1, 0.5)
    local v
    for i = 0, number do
      v = Vertex{position     = Vector{math.random(200), math.random(200)},
                        force         = Vector(),
                        speed         = Vector(),
                        mu_frottement = -0.2,
                        mass          = 0.2,}
      f:addVertex(v)
    end
    return f
end

app = mimas.Application()
win = mimas.Window()
win:setMouseTracking(true)
point_choisi = {}
is_dragging = false
mouse = {xCoord=0, yCoord=0}

--flub  = makeFlubber(0.5)
--flub2 = makeFlubber(0.9)
flub = makeFlubberWithRandomPoints(15)

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
  
  p:fillRect(0, 0, w, h, White)
  
  --calcul des liens entre les points
  flub:update()
  flub:qtWoodstockDraw(p, 
    false, -- points
    false, -- force
    true, -- edges
    true, -- shape
    false, -- bezier ctrl
    20    --color cycle time
  )
  
  --flub2:update()
  --[[flub2:qtDraw(p, 
    false, -- points
    false, -- force
    false, -- edges
    true,  -- shape
    false  -- bezier ctrl
  )--]]

	win:update()
end


win:show()
app:exec()

