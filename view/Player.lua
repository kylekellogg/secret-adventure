require 'libs/middleclass'

require 'view/Animation'
require 'view/DisplayObject'

Player = class( 'Player', DisplayObject )

local updateLinearDamping = false
local linearDamping = 1

local originalRadius
local originalMass
local mult

local cam

function Player:initialize( x, y, width, height, world, signal )
	DisplayObject.initialize( self, x, y, width, height )

	self.ableToJump = false
	self.jumping = false

	self.signal = signal

	-- 0: jump
	-- 1: land 1
	-- 2: land 2
	-- 3: blink
	-- 4: normal
	-- 5: hit
	self.anim = Animation:new( self.x, self.y, 355, 319, 'images/cat.png', 355, 319, 0 )

	self.world = world

	originalRadius = width

	self:reset()

	self.signal.register( 'player_jump', function( override, grounded )
		if self.body == nil then return end
		if (self.jumping == false and self.ableToJump == true) or override == true then
			self.jumping = true
			self.ableToJump = false

			local jump 
			if grounded then
				jump = self:getForceFor( -400 )
			else
				jump = self:getForceFor( -200 )
			end
			
			self.body:applyLinearImpulse( 0, jump )
		end
	end )

	self.signal.register( 'reset_player_jump', function()
		self.jumping = false
	end )

	self.signal.register( 'player_sticking', function( m )
		updateLinearDamping = true
		linearDamping = m
	end )

	self.signal.register( 'player_lose_mass', function( multiplier )
		mult = multiplier or 1.0

		self.mass = math.max( 0, self.mass - (0.0005 * mult) )
		self.dirty = true
	end )
end

function Player:update( dt )
	DisplayObject.update( self, dt )

	if self.dirty == true then
		self.dirty = false
		do self:generateFixture() end
	end

	if updateLinearDamping then
		updateLinearDamping = false
		do self.body:setLinearDamping( linearDamping ) end
	end

	if love.keyboard.isDown( 'a' ) or love.keyboard.isDown( 'left' ) then
		self.body:applyForce( self:getForceFor( -750 ), 0 )
		-- self.body:applyLinearImpulse( self:getForceFor( -15 ), 0 )
	end

	if love.keyboard.isDown( 'd' ) or love.keyboard.isDown( 'right' ) then
		self.body:applyForce( self:getForceFor( 750 ), 0 )
		-- self.body:applyLinearImpulse( self:getForceFor( 15 ), 0 )
	end

	local r, mm = self.shape:getRadius(), 2.3 + self:getMassModifier()
	local sx = r / self.anim.width * mm
	local sy = r / self.anim.height * mm
	local s = math.max( sx, sy )

	self.anim:scale( s )
	self.anim.x = self.body:getX() - ((self.anim.width * s) * 0.5)
	self.anim.y = self.body:getY() - ((self.anim.height * s) * 0.5)
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

	-- love.graphics.setColor( 255, 0, 0, 255 )
	-- love.graphics.circle( 'line', self.body:getX(), self.body:getY(), originalRadius )

	-- love.graphics.setColor( 0, 0, 0, 255 )
	-- love.graphics.circle( 'fill', self.body:getX(), self.body:getY(), self.shape:getRadius() )

	love.graphics.setColor( 255, 255, 255, 255 )
	self.anim:draw()
end

function Player:reset()
	self.anim:seek( 4 )
	self.anim:stop()

	self.mass = 1.0

	self:destroy()
	self.body = love.physics.newBody( self.world, self.x, self.y, 'dynamic' )
	self.body:setLinearDamping( 1 )
	self:generateFixture()

	self.previousY = self.body:getY()

	self.dirty = false
end

function Player:destroy()
	if self.fixture ~= nil then
		self.fixture:destroy()
		self.fixture = nil
		self.shape = nil
		self.body = nil
	end
end

function Player:generateFixture()
	local r
	if self.shape ~= nil then
		r = originalRadius * self.mass
	else
		r = originalRadius
	end

	if self.fixture ~= nil then
		self.fixture:destroy()
		self.fixture = nil
	end

	self.shape = love.physics.newCircleShape( 0, 0, r )

	self.fixture = love.physics.newFixture( self.body, self.shape, 1 )
	self.fixture:setDensity( 1 )
	self.fixture:setFriction( 1 )

	local xx, yy, rr, ii = self.body:getMassData()

	if originalMass == nil then
		originalMass = rr
	end

	local md = originalMass * self.mass

	self.fixture:setRestitution( 0.34 )
	self.fixture:setUserData( 'player' )

	self.body:setMassData( xx, yy, md, ii )
end

function Player:getMassModifier()
	local high = originalMass or self.mass
	return 1.0 - (high - self.mass)
end

function Player:getForceFor( velocity )
	if self.body == nil then return 0 end
	local xx, yy, rr, ii = self.body:getMassData()
	return rr * velocity
end
