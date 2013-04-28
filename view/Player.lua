require 'libs/middleclass'

require 'view/Animation'
require 'view/DisplayObject'

Player = class( "Player", DisplayObject )

function Player:initialize( x, y, width, height, world, signal )
	DisplayObject.initialize( self, x, y, width, height )

	self.ableToJump = false
	self.jumping = false

	self.signal = signal
	self.originalMass = 1.0
	self.mass = 1.0

	self.world = world
	self.body = love.physics.newBody( self.world, self.x, self.y, 'dynamic' )
	self.body:setLinearDamping( 0.5 )
	self:generateFixture()

	self.previousY = self.body:getY()

	self.dirty = false

	-- 0: jump
	-- 1: land 1
	-- 2: land 2
	-- 3: blink
	-- 4: normal
	-- 5: hit
	self.anim = Animation:new( self.x, self.y, 355, 319, 'images/cat.png', 355, 319, 0 )
	self.anim:seek( 4 )
	self.anim:stop()

	self.signal.register( 'player_jump', function( override )
		if (self.jumping == false and self.ableToJump == true) or override == true then
			self.jumping = true
			self.ableToJump = false
			--	For debugging jump heights
			--print( 'starting y: ' .. self.body:getY() )
			print( 'modifier is ' .. self:getMassModifier() .. ' & force is ' .. (-750 * self:getMassModifier()) )
			self.body:applyLinearImpulse( 0, -750 * self:getMassModifier() )
		end
	end )

	self.signal.register( 'reset_player_jump', function()
		self.jumping = false
	end )

	self.signal.register( 'player_sticking', function( m )
		self.body:setLinearDamping( m )
	end )

	self.signal.register( 'player_lose_mass', function( multiplier )
		local m = multiplier or 1.0

		self.mass = self.mass - (0.0005 * m)
		self.dirty = true
	end )
end

function Player:update( dt )
	DisplayObject.update( self, dt )

	self.anim:scale( (self.shape:getRadius() / self.anim.width) * (1.0 + self:getMassModifier()) )
	self.anim.x = self.body:getX() - ((self.anim.width * self.anim.scaleX) * 0.5)
	self.anim.y = self.body:getY() - ((self.anim.height * self.anim.scaleY) * 0.5)
	self.anim:update( dt )

	if self.previousY == self.body:getY() then
		self.ableToJump = true
	else
		self.ableToJump = false
	end

	self.previousY = self.body:getY()
end

function Player:draw()
	DisplayObject.draw( self )

	--love.graphics.setColor( 0, 0, 0, 255 )
	--love.graphics.circle( 'fill', self.body:getX(), self.body:getY(), self.shape:getRadius() )

	love.graphics.setColor( 255, 255, 255, 255 )
	self.anim:draw()
end

function Player:generateFixture()
	if self.fixture ~= nil then
		self.fixture:destroy()
	end

	self.shape = love.physics.newCircleShape( 0, 0, self.width * self:getMassModifier() )
	self.fixture = love.physics.newFixture( self.body, self.shape, 1 * (1.0 + self:getMassModifier()) )
	self.fixture:setRestitution( 0.34 * self:getMassModifier() )
	self.fixture:setUserData( 'player' )
end

function Player:getMassModifier()
	return 1.0 - (self.originalMass - self.mass)
end
