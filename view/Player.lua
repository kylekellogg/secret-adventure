require 'libs/middleclass'

require 'view/DisplayObject'

Player = class( "Player", DisplayObject )

function Player:initialize( x, y, width, height, world )
	DisplayObject.initialize( self, x, y, width, height )

	self.world = world
	self.body = love.physics.newBody( self.world, self.x, self.y, 'dynamic' )
	self.shape = love.physics.newCircleShape( self.x, self.y, self.width )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
	self.fixture:setRestitution( math.random( 25, 75 ) / 100 )
end

function Player:update( dt )
	DisplayObject.update( self, dt )
end

function Player:draw()
	DisplayObject.draw( self )

	love.graphics.setColor( 0, 0, 0 )
	love.graphics.circle( 'fill', self.body:getX(), self.body:getY(), self.shape:getRadius() )
end
