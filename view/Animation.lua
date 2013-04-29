require 'libs/middleclass'
require 'libs/AnAL'

require 'view/Image'

Animation = class( 'Animation', Image )

Animation.static.LOOP = 'loop'
Animation.static.BOUNCE = 'bounce'
Animation.static.ONCE = 'once'

Animation.static.DEFAULT_FPS = 1.0/30.0

function Animation:initialize( x, y, width, height, src, frameW, frameH, frameSpeed )
	Image.initialize( self, x, y, width, height, src )

	self._anim = newAnimation( self._image, frameW, frameH, frameSpeed, 0 )
end

function Animation:update( dt )
	Image.update( self )

	self._anim:update( dt )
end

function Animation:draw()
	self._anim:draw( self.x, self.y, self.rotation, self.scaleX, self.scaleY )
end

function Animation:add( x, y, w, h, delay )
	self._anim:add( x, y, w, h, delay )
end

function Animation:play()
	self._anim:play()
end

function Animation:stop()
	self._anim:stop()
end

function Animation:reset()
	self._anim:reset()
end

function Animation:seek( frame )
	self._anim:seek( frame )
end

function Animation:setMode( mode )
	self._anim:setMode( mode )
end

function Animation:setDelay( frame, delay )
	self._anim:setDelay( frame, delay )
end

function Animation:setSpeed( speed )
	self._anim:setSpeed( speed )
end

function Animation:getCurrentFrame()
	self._anim:getCurrentFrame()
end

function Animation:getSize()
	self._anim:getSize()
end

function Animation:getSpeed()
	self._anim:getSpeed()
end

function Animation:getWidth()
	self._anim:getWidth()
end

function Animation:getHeight()
	self._anim:getHeight()
end
