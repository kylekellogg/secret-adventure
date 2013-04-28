require 'libs/middleclass'

require 'view/DisplayObject'

Player = class( "Player", DisplayObject )

Player.static.REGULAR_DAMPING = 0.05
Player.static.SLIPPING_DAMPING = 0
Player.static.STICKING_DAMPING = 0.1

function Player:initialize( x, y, width, height, world )
	DisplayObject.initialize( self, x, y, width, height )

	self.world = world
	self.body = love.physics.newBody( self.world, self.x, self.y, 'dynamic' )
	self.body:setLinearDamping( Player.REGULAR_DAMPING )
	self:generateFixture()

	self.hasMadeContact = false
end

function Player:update( dt )
	DisplayObject.update( self, dt )
end

function Player:draw()
	DisplayObject.draw( self )

	love.graphics.setColor( 0, 0, 0 )
	love.graphics.circle( 'fill', self.body:getX(), self.body:getY(), self.shape:getRadius() )
end

function Player:generateFixture()
	if self.shape ~= nil then
		self.shape:destroy()
	end

	if self.fixture ~= nil then
		self.fixture:destroy()
	end

	self.shape = love.physics.newCircleShape( 0, 0, self.width )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
	self.fixture:setRestitution( 0.34 )
	self.fixture:setUserData( 'player' )
end
