require 'libs/Beetle'
require 'libs/middleclass'
Gamestate = require 'libs/hump/gamestate'
Signal = require 'libs/hump/signal'

require 'States'
require 'states/TestState'
require 'states/MainState'
require 'states/LevelOneState'

function love.load()
	beetle.load()
	beetle.setKey( 'x' )
	
	States:add( TestState:new( 'test', beetle, Signal ) )
	States:add( MainState:new( 'menu', beetle, Signal ) )
	States:add( LevelOneState:new( 'levelOne', beetle, Signal ) )

	Signal.register( 'switch_to_menu', function() Gamestate.switch( States:get( 'menu' ) ) end )
	
	Gamestate.switch( States:get( 'test' ) )

	love.graphics.setBackgroundColor( 255, 255, 255 )
	love.graphics.setMode( 600, 900, false, true, 0) --set the window dimensions to 650 by 650
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

function love.mousereleased( x, y, button )
	Gamestate.mousereleased( x, y, button )
end

function love.keypressed( key, code )
	Gamestate.keypressed( key, code )
end

function love.keyreleased( key, code )
	Gamestate.keyreleased( key, code )
	beetle.key( key )
end

function love.focus( f )
	Gamestate.focus( f )
end
