require 'libs/Beetle'
require 'libs/middleclass'
Gamestate = require 'libs/hump/gamestate'
Signal = require 'libs/hump/signal'

require 'States'
require 'states/TestState'
require 'states/MainState'

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
	beetle.load()
	beetle.setKey( 'x' )
	
	States:add( TestState:new( 'test', beetle, Signal ) )
	States:add( MainState:new( 'menu', beetle, Signal ) )

	Signal.register( 'switch_to_menu', function() Gamestate.switch( States:get( 'menu' ) ) end )
	
	Gamestate.switch( States:get( 'test' ) )
end

function love.update( dt )
	Gamestate.update( dt )
end

function love.draw()
	Gamestate.draw()
	beetle.draw()
end

function love.mousepressed( x, y, button )
	Gamestate.mousepressed( x, y, button )
end

function love.keyreleased( key )
	Gamestate.keyreleased( key )
	beetle.key( key )
end
