require 'libs/middleclass'

require 'view/Image'
require 'view/Animation'

require 'Splatter'

require 'State'

TestState = class( 'TestState', State )

function TestState:initialize( name, beetle, signal )
	State.initialize( self, name, beetle, signal )
end

function TestState:init()
	self.background = Image:new( love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5, nil, nil, 'images/background.png' )
	self.splatter = Splatter:new()
	self.test = Animation:new( math.random( love.graphics.getWidth() ), math.random( love.graphics.getHeight() ), nil, nil, 'images/explosion.png', 96, 96, Animation.DEFAULT_FPS )
	self.test:setMode( Animation.LOOP )
	self.splatterDebug = self.beetle.add( 'splatters', 0 )
end

function TestState:update( dt )
	self.test:update( dt )
end

function TestState:draw()
	self.background:draw()
	self.splatter:draw()
	self.test:draw()
end

function TestState:mousepressed( x, y, button )
	if ( button == 'l' ) then
		local w = math.random( 100 )
		local h = math.random( 100 )
		self.splatter:add( x, y, w, h )
		self.beetle.update( self.splatterDebug, table.getn( self.splatter.splats ) )
	end
end

function TestState:keyreleased( key )
	if ( key == 'm' ) then
		self.signal.emit( 'switch_to_menu' )
	end
end
