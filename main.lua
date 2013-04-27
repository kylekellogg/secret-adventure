require 'libs/middleclass'
require 'libs/beetle'

require 'splatter'

local splatter
local background
local test

local splatterDebug

function love.conf( t )
	t.title = "Secret Adventure!"        -- The title of the window the game is in (string)
	t.author = "Kyle Kellogg, Dan Barron, Michael Schondek"        -- The author of the game (string)
	t.url = nil                 -- The website of the game (string)
	t.identity = nil            -- The name of the save directory (string)
	t.version = "0.8.0"         -- The LÖVE version this game was made for (string)
	t.console = false           -- Attach a console (boolean, Windows only)
	t.release = false           -- Enable release mode (boolean)
	t.screen.width = 800        -- The window width (number)
	t.screen.height = 600       -- The window height (number)
	t.screen.fullscreen = false -- Enable fullscreen (boolean)
	t.screen.vsync = true       -- Enable vertical sync (boolean)
	t.screen.fsaa = 0           -- The number of FSAA-buffers (number)
	t.modules.joystick = true   -- Enable the joystick module (boolean)
	t.modules.audio = true      -- Enable the audio module (boolean)
	t.modules.keyboard = true   -- Enable the keyboard module (boolean)
	t.modules.event = true      -- Enable the event module (boolean)
	t.modules.image = true      -- Enable the image module (boolean)
	t.modules.graphics = true   -- Enable the graphics module (boolean)
	t.modules.timer = true      -- Enable the timer module (boolean)
	t.modules.mouse = true      -- Enable the mouse module (boolean)
	t.modules.sound = true      -- Enable the sound module (boolean)
	t.modules.physics = true    -- Enable the physics module (boolean)
end

function love.load()
	background = love.graphics.newImage( 'images/background.png' )
	splatter = Splatter:new()
	beetle.load()
	beetle.show()

	splatterDebug = beetle.add( 'splatters', 0 )
end

function love.update()
end

function love.draw()
	love.graphics.draw( background, 0, 0, 0, 1, 1, 0, 0 )
	splatter:draw()
	beetle.draw()
end

function love.mousepressed( x, y, button )
	print( 'button : ' .. button )
	if ( button == "l" ) then
		local w = math.random( 100 )
		local h = math.random( 100 )
		splatter:add( x, y, w, h )
		beetle.update( splatterDebug, table.getn( splatter.splats ) )
	end
end
