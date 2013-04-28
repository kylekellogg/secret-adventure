require 'libs/Beetle'
require 'libs/middleclass'
Gamestate = require 'libs/hump/gamestate'
Signal = require 'libs/hump/signal'

require 'States'
require 'states/TestState'
require 'states/MainState'
require 'states/LevelOneState'
require 'states/LevelTwoState'
require 'states/LevelThreeState'
require 'states/LevelFourState'

function love.load()
	beetle.load()
	beetle.setKey( 'x' )
	
	States:add( TestState:new( 'test', beetle, Signal ) )
	States:add( MainState:new( 'menu', beetle, Signal ) )
	States:add( LevelOneState:new( 'levelOne', beetle, Signal ) )
	States:add( LevelTwoState:new( 'levelTwo', beetle, Signal ) )
	States:add( LevelThreeState:new( 'levelThree', beetle, Signal ) )
	States:add( LevelFourState:new( 'levelFour', beetle, Signal ) )

	Signal.register( 'switch_to_menu', function() Gamestate.switch( States:get( 'menu' ) ) end )
	Signal.register( 'switch_to_level_one', function() Gamestate.switch( States:get( 'levelOne' ) ) end )
	Signal.register( 'switch_to_level_two', function() Gamestate.switch( States:get( 'levelTwo' ) ) end )
	Signal.register( 'switch_to_level_three', function() Gamestate.switch( States:get( 'levelThree' ) ) end )
	Signal.register( 'switch_to_level_four', function() Gamestate.switch( States:get( 'levelFour' ) ) end )
	
	Gamestate.switch( States:get( 'test' ) )

	love.graphics.setBackgroundColor( 255, 255, 255 )
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
