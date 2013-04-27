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

function Platform:initialize( x, y, width, height, src, mode )
	Image.initialize( self, x, y, width, height, src )

	self.scaleX = self.width / self._image:getWidth();
	self.scaleY = self.height / self._image:getHeight();

	print( 'scales x and y: ' .. tostring( self.scaleX ) .. ', ' .. tostring( self.scaleY ) )

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
end

function Platform:update( dt )
	Image.update( self, dt )

	self.updates[ self:getMode() ]()
end

function Platform:draw()
	Image.draw( self )
end

function Platform:setMode( mode )
	self.mode = mode
end

function Platform:getMode()
	return self.mode
end