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


function makeFlubber()
  local f = Flubber(-0.2, 70, 100, 300)
  local v1, v2, v3, v4 = makeVertex()
  f:addVertex(v1)
  f:addVertex(v2)
  f:addVertex(v3)
  f:addVertex(v4)
  return f
end

Selection_Dist = 15
Drag_Dist = 10


app = mimas.Application()
win = mimas.Window()
win:setMouseTracking(true)
point_choisi = {}
is_dragging = false
mouse = {xCoord=0, yCoord=0}

flub = makeFlubber()

local function manhattanDist(a, x, y)
  return math.abs(x - a[1]) + math.abs(y - a[2])
end

function win.click(x, y, type) --(x, y, type, btn, mod) --type: mimas.MousePress, MouseRelease, DoubleClick
  -- si la souris est enfoncee
  if type==mimas.MousePress then
    --verifie si un point est a proximite
    for i, vertex in ipairs(flub.vertex_list) do
      if manhattanDist(vertex.position, x, y) < Selection_Dist then
        point_choisi = vertex.position
        break
      end
    end
    --si un point a ete choisi dans la boucle, on sauve ses coordonnees d'origine
    if point_choisi then
      point_choisi.old_x = point_choisi[1]
      point_choisi.old_y = point_choisi[2]
    else
      flub:addVertexFromPosition(Vector{x, y})
    end
  -- si la souris est relachee
  elseif type==mimas.MouseRelease then
    --le relachement a lieu pendant un drag, on remet a false le drag, et on reinitialise le point selectionne
    if is_dragging then
      is_dragging = false
      point_choisi.old_x = nil
      point_choisi.old_y = nil
      point_choisi = nil
    end
    win:update()
  end

end

function win.mouse(x, y)
  
  mouse.xCoord = x
  mouse.yCoord = y
  if not is_dragging and point_choisi then
    is_dragging = true
  end
  if is_dragging then
    point_choisi[1] = x
    point_choisi[2] = y
    win:update()
  end
end

function win.paint(p, w, h)
  
  
  --calcul des liens entre les points
  flub:update()
  flub:draw(p, false)

	win:update()
end


win:show()
app:exec()

--test.all()
