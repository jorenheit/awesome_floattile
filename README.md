Sometimes you might want to work in a floating environment within Awesome WM. This module provides some extensions to make it possible to tile your windows even now.

INSTALLATION:
1)
  cd ~/.config/awesome
  git clone https://github.com/jorenheit/awesome_floattile.git floattile

2) Add to rc.lua:
   local floattile = require("floattile")

3) Add your keybindings
   The function for tiling is called floattile.tile(), it takes a string, which should be one of the following: "left", "right", "up", "down", "full".
   The strings are pretty self-explanatory...

4) Optional: replace move/resize functions
   This module also provides alternative move/resize functionality. For one, they call floattile.reset() to reset the state of the floating client. Also, they make it possible to move/resize clients that are maximized, which is not possible with the default functions. E.g. replace

"awful.button({ modkey }, 1, awful.mouse.client.move)"

by

"awful.button({ modkey }, 1, floattile.move)"

(same for resize)