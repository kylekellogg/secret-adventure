require 'libs/middleclass'

require 'view/DisplayObject'

Player = class( "Player", DisplayObject )

function Player:initialize( x, y, width, height, world, signal )
	DisplayObject.initialize( self, x, y, width, height )

	self.world = world
	self.body = love.physics.newBody( self.world, self.x, self.y, 'dynamic' )
	self:generateFixture()

	self.ableToJump = false
	self.jumping = false

	self.signal = signal

	self.previousY = self.body:getY()

	self.signal.register( 'player_jump', function( override )
		if (self.jumping == false and self.ableToJump == true) or override == true then
			self.jumping = true
			self.ableToJump = false
			--	For debugging jump heights
			--print( 'starting y: ' .. self.body:getY() )
			self.body:applyLinearImpulse( 0, -750 )
		end
	end )

	self.signal.register( 'reset_player_jump', function()
		self.jumping = false
	end )
end

function Player:update( dt )
	DisplayObject.update( self, dt )

	if self.previousY == self.body:getY() then
		self.ableToJump = true
	else
		self.ableToJump = false
	end

	self.previousY = self.body:getY()
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
