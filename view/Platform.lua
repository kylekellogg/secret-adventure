require 'libs/middleclass'

Vector = require 'libs/hump/vector'

require 'view/Animation'
require 'view/Image'

Platform = class( 'Platform', Image )

Platform.static.STATIC 				= 1
Platform.static.BOUNCING			= 2
Platform.static.CLEANING			= 3
Platform.static.ENDING				= 4
Platform.static.MOVING_H			= 5
Platform.static.MOVING_V			= 6
Platform.static.SLIPPING			= 7
Platform.static.STICKING			= 8
Platform.static.TELEPORTING			= 9

Platform.static.MOVING_H_BOUNCING	= 10
Platform.static.MOVING_V_BOUNCING	= 11
Platform.static.MOVING_H_SLIPPING	= 12
Platform.static.MOVING_V_SLIPPING	= 13

function Platform:initialize( x, y, mode, world, width, height )
	Image.initialize( self, x, y, width, height, 'images/platform.png' )

	self.scaleX = self.width / self._image:getWidth()
	self.scaleY = self.height / self._image:getHeight()

	self.timeAlive = 0
	self.frameCounter = 0

	self._markings = {}
	self._prevPosition = Vector(0,0)
	self._movementDelta = Vector(0,0)
	self.marking = Image:new( 0, 0, 0, 0, 'images/marking.png' );
	self.mquad = love.graphics.newQuad( 0, 0, 25, 25, 25, 25 );

	local types = {
		'static',
		'bouncing',
		'cleaning',
		'ending',
		'moving-h',
		'moving-v',
		'slipping',
		'sticking',
		'teleporting',
		'moving-h-bouncing',
		'moving-v-bouncing',
		'moving-h-slipping',
		'moving-v-slipping'
	}

	self._movement = 100;

	self.updates = {
		--	STATIC
		function( dt ) return types[ self:getMode() ] end,
		--	BOUNCING
		function( dt ) return types[ self:getMode() ] end,
		--	CLEANING
		function( dt ) return types[ self:getMode() ] end,
		--	ENDING
		function( dt ) return types[ self:getMode() ] end,
		--	MOVING_H
		function( dt )
			local oldX = self.body:getX()
			self.body:setX( self.x + self._movement * math.sin( self.timeAlive ) )
			for _,v in pairs( self._markings ) do
				v.x = v.x - (oldX - self.body:getX())
			end
			return types[ self:getMode() ]
		end,
		--	MOVING_V
		function( dt )
			local oldY = self.body:getY()
			self.body:setY( self.y + self._movement * math.sin( self.timeAlive ) )
			for _,v in pairs( self._markings ) do
				v.y = v.y - (oldY - self.body:getY())
			end
			return types[ self:getMode() ]
		end,
		--	SLIPPING
		function( dt ) return types[ self:getMode() ] end,
		--	STICKING
		function( dt ) return types[ self:getMode() ] end,
		--	TELEPORTING
		function( dt ) return types[ self:getMode() ] end,
		--	MOVING_H_BOUNCING
		--	MOVING_H
		function( dt )
			local oldX = self.body:getX()
			self.body:setX( self.x + self._movement * math.sin( self.timeAlive ) )
			for _,v in pairs( self._markings ) do
				v.x = v.x - (oldX - self.body:getX())
			end
			return types[ self:getMode() ]
		end,
		--	MOVING_V_BOUNCING
		function( dt )
			local oldY = self.body:getY()
			self.body:setY( self.y + self._movement * math.sin( self.timeAlive ) )
			for _,v in pairs( self._markings ) do
				v.y = v.y - (oldY - self.body:getY())
			end
			return types[ self:getMode() ]
		end,
		--	MOVING_H_SLIPPING
		--	MOVING_H
		function( dt )
			local oldX = self.body:getX()
			self.body:setX( self.x + self._movement * math.sin( self.timeAlive ) )
			for _,v in pairs( self._markings ) do
				v.x = v.x - (oldX - self.body:getX())
			end
			return types[ self:getMode() ]
		end,
		--	MOVING_V_BOUNCING
		function( dt )
			local oldY = self.body:getY()
			self.body:setY( self.y + self._movement * math.sin( self.timeAlive ) )
			for _,v in pairs( self._markings ) do
				v.y = v.y - (oldY - self.body:getY())
			end
			return types[ self:getMode() ]
		end
	}

	self:setMode( mode or Platform.STATIC )

	self.door = nil

	if self:getMode() == Platform.ENDING then
		self.door = Animation:new( self.x + (self.width * 0.5) - 103, self.y - 413, 206, 413, 'images/door.png', 206, 413, 0 )
		self.door:seek( 1 )
		self.door:stop()
		self.door.scaleX = self.scaleX
		self.door.scaleY = self.scaleY
	end

	self.world = world
	self.body = love.physics.newBody( self.world, self.x + (self.width * 0.5), self.y + (self.height * 0.5), 'static' )
	self.shape = love.physics.newRectangleShape( 0, 0, self.width, self.height )
	self.fixture = love.physics.newFixture( self.body, self.shape, 5 )
	self.fixture:setFriction( 100 )
	self.fixture:setUserData( 'platform-' .. types[ self:getMode() ] )

	-- if bodyType == 'dynamic' then
	-- 	self.body:setGravityScale( 0 )
	-- end

	if self.mode == 2 or self.mode == 10 or self.mode == 11 then
		self.fixture:setRestitution( 1.0 )
	elseif self.mode == 7 or self.mode > 11 then
		--	
	else
		--	
	end
end

function Platform:update( dt )
	Image.update( self, dt )

	if self.door ~= nil then
		self.door:update( dt )
	end

	self.frameCounter = self.frameCounter + 1
	self.timeAlive = self.timeAlive + dt

	do self.updates[ self:getMode() ]( dt ) end
end

function Platform:draw()
	love.graphics.setColor( 255, 255, 255, 255 )
	Image.draw( self )

	if self.door ~= nil then
		self.door:draw()
	end

	-- if self.mode == 2 or self.mode == 10 or self.mode == 11 then
	-- 	love.graphics.setColor( 0, 255, 0, 255 )
	-- elseif self.mode == 7 or self.mode > 11 then
	-- 	love.graphics.setColor( 0, 0, 255, 255 )
	-- elseif self.mode == 8 then
	-- 	love.graphics.setColor( 255, 255, 0, 255 )
	-- else
	-- 	love.graphics.setColor( 255, 0, 0, 255 )
	-- end
	-- love.graphics.polygon( 'fill', self.body:getWorldPoints( self.shape:getPoints() ) )

	local stencilFunction = function()
		love.graphics.polygon( 'fill', self.body:getWorldPoints( self.shape:getPoints() ) )
	end

	love.graphics.setStencil( stencilFunction )
	love.graphics.setColor( 0, 0, 0, 255 )
	for _,v in pairs( self._markings ) do
		love.graphics.drawq( self.marking:getRawImage(), self.mquad, v.x - 12.5, v.y - 12.5 )
	end
	love.graphics.setInvertedStencil( stencilFunction )
end

function Platform:stencilFunction( x1, y1, x2, y2, ... )
	love.graphics.polygon( 'fill', x1, y1, x2, y2, ... )
end

function Platform:addMarking( x, y )
	table.insert( self._markings, Vector( self.body:getLocalVector( x, y ) ) )
end

function Platform:hasFixture( fixture )
	return fixture == self.fixture;
end

function Platform:setMode( mode )
	self.mode = mode
end

function Platform:getMode()
	return self.mode
end
