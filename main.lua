require 'libs/Beetle'
require 'libs/middleclass'
Gamestate = require 'libs/hump/gamestate'
Signal = require 'libs/hump/signal'

require 'states/States'
require 'states/State'
require 'states/TestState'
require 'states/MainState'
require 'states/LevelOneState'
require 'states/LevelTwoState'
require 'states/LevelThreeState'
require 'states/LevelFourState'

function love.load()
	love.graphics.setBackgroundColor( 255, 255, 255 )
	love.graphics.setCaption( 'Secret Adventure!' )
	
	beetle.load()
	beetle.setKey( 'x' )
	
	States:add( TestState:new( State.TEST, beetle, Signal ) )
	States:add( MainState:new( State.MAIN, beetle, Signal ) )
	States:add( LevelOneState:new( State.LEVEL_ONE, beetle, Signal ) )
	States:add( LevelTwoState:new( State.LEVEL_TWO, beetle, Signal ) )
	States:add( LevelThreeState:new( State.LEVEL_THREE, beetle, Signal ) )
	States:add( LevelFourState:new( State.LEVEL_FOUR, beetle, Signal ) )

	Signal.register( 'set_state', function( s )
		Gamestate.switch( States:get( s ) )
	end )
	
	Gamestate.switch( States:get( State.LEVEL_ONE ) )
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
