require 'libs/middleclass'

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

function Platform:initialize( x, y, width, height, src, mode, world )
	Image.initialize( self, x, y, width, height, src )

	self.scaleX = self.width / self._image:getWidth()
	self.scaleY = self.height / self._image:getHeight()

	self.updates = {
		--	STATIC
		function() return 'static' end,
		--	BOUNCING
		function() return 'bouncing' end,
		--	CLEANING
		function() return 'cleaning' end,
		--	ENDING
		function() return 'ending' end,
		--	MOVING_H
		function() return 'moving horizontal' end,
		--	MOVING_V
		function() return 'moving vertical' end,
		--	SLIPPING
		function() return 'slipping' end,
		--	STICKING
		function() return 'sticking' end,
		--	TELEPORTING
		function() return 'teleporting' end,
		--	MOVING_H_BOUNCING
		function() return 'moving horizontal, bouncing' end,
		--	MOVING_V_BOUNCING
		function() return 'moving vertical, bouncing' end,
		--	MOVING_H_SLIPPING
		function() return 'moving horizontal, slipping' end,
		--	MOVING_V_BOUNCING
		function() return 'moving vertical, slipping' end
	}

	self:setMode( mode or Platform.STATIC )

	local bodyType = 'static'
	if ( self.mode == 5 or self.mode == 6 or self.mode > 9 ) then
		bodyType = 'dynamic'
	end

	self.world = world
	self.body = love.physics.newBody( self.world, self.width * 0.5, self.width - (self.height*0.5), 'static' )
	--self.body:setAngle( math.rad( math.random( 45 ) ) )
	self.shape = love.physics.newRectangleShape( self.x, self.y, self.width, self.height )
	self.fixture = love.physics.newFixture( self.body, self.shape, 5 )

	if ( self.mode == 2 or self.mode == 10 or self.mode == 11 ) then
		self.fixture:setRestitution( 0.6)
	end
end

function Platform:update( dt )
	Image.update( self, dt )

	self.updates[ self:getMode() ]()
end

function Platform:draw()
	--Image.draw( self )
	love.graphics.setColor( 255, 0, 0 )
	love.graphics.polygon( 'fill', self.body:getWorldPoints( self.shape:getPoints() ) )
end

function Platform:setMode( mode )
	self.mode = mode
end

function Platform:getMode()
	return self.mode
end
