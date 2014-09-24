-- Standard awesome library
local awful = require("awful")
local wibox = require("wibox")

local client = client
local mouse = mouse
local screen = screen

module ("floattile")

floatTile = {}

local function left(c, cg, sg)

   local x, y, width, height

   if floatTile[c].right and (floatTile[c].up or floatTile[c].down) then
      height = cg.height
      y = cg.y
   elseif not floatTile[c].left and (floatTile[c].up or floatTile[c].down) then
      y = cg.y
      height = cg.height
   else
      y = sg.y
      height = sg.height
      floatTile[c].up = false
      floatTile[c].down = false
   end

   floatTile[c].left = true
   floatTile[c].right = false

   x = sg.x
   width = sg.width / 2

   return x, y, width, height
end

local function right(c, cg, sg)

   local x, y, width, height

   if floatTile[c].left and (floatTile[c].up or floatTile[c].down) then
      height = cg.height
      y = cg.y
   elseif not floatTile[c].right and (floatTile[c].up or floatTile[c].down) then
      y = cg.y
      height = cg.height
   else
      y = sg.y
      height = sg.height
      floatTile[c].up = false
      floatTile[c].down = false
   end
   
   floatTile[c].left = false
   floatTile[c].right = true
   
   x = sg.x + sg.width/2
   width = sg.width / 2

   return x, y, width, height
end

local function up(c, cg, sg)

   local x, y, width, height

   if floatTile[c].up and not (floatTile[c].left or floatTile[c].right) then
      return sg.x, sg.y, sg.width, sg.height
   elseif not (floatTile[c].left or floatTile[c].right) then
      x = sg.x
      width = sg.width
   elseif floatTile[c].up then
      x = sg.x
      width = sg.width
      floatTile[c].left = false
      floatTile[c].right = false
   else
      x = cg.x
      width = cg.width
   end
   
   floatTile[c].up = true
   floatTile[c].down = false

   y = sg.y
   height = sg.height / 2

   return x, y, width, height
end

local function down(c, cg, sg)

   local x, y, width, height

   if not (floatTile[c].left or floatTile[c].right) then
      x = sg.x
      width = sg.width
   elseif floatTile[c].down then
      x = sg.x 
      width = sg.width
      floatTile[c].left = false
      floatTile[c].right = false
   else
      x = cg.x
      width = cg.width
   end

   floatTile[c].up = false
   floatTile[c].down = true

   y = sg.y + sg.height / 2
   height = sg.height / 2

   return x, y, width, height
end


local function reset(c)
   if c == nil then return end
   
   floatTile[c] = {}
   floatTile[c].left = false
   floatTile[c].right = false
   floatTile[c].up = false
   floatTile[c].down = false
end

local function full(c, sg)
   reset(c)
   c.maximized = true
   return sg.x, sg.y, sg.width, sg.height
end

function tile(dir)
   local c = client.focus
   
   if c == nil then 
      return 
   end

   if not floatTile[c] then
      reset(c)
   end

   c.maximized = false
   c.minimized = false

   local s = mouse.screen
   local cg = c:geometry()
   local sg = screen[s].workarea

   local x, y, width, height

   if dir == "left" then
      x,y,width,height = left(c, cg, sg)
   elseif dir == "right" then
      x,y,width,height = right(c, cg, sg)
   elseif dir == "up" then
      x,y,width,height = up(c, cg, sg)
   elseif dir == "down" then
      x,y,width,height = down(c, cg, sg)
   elseif dir == "full" then
      x,y,width,height = full(c, sg)
   end

   c:geometry({x = x, y = y, width = width, height = height})
   c:raise()
end

function move(c)
   if awful.layout.get(c.screen) == awful.layout.suit.floating then
      c:raise()
      reset(c)
      cg = c:geometry()
      c.maximized_horizontal = false
      c.maximized_vertical = false
      c:geometry(cg)
   end

   awful.mouse.client.move(c)
end 

function resize(c)
   if awful.layout.get(c.screen) == awful.layout.suit.floating then
      c:raise()
      reset(c)
      cg = c:geometry()
      c.maximized_horizontal = false
      c.maximized_vertical = false
      c:geometry(cg)
   end
   awful.mouse.client.resize(c)
end 


return {tile = tile, move = move, resize = resize}
