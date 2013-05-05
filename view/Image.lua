require 'libs/middleclass'

require 'view/DisplayObject'

Image = class( 'Image', DisplayObject )

function Image:initialize( x, y, width, height, src )
	DisplayObject.initialize( self, x, y, width, height )

	self._image = love.graphics.newImage( src )
	self.width = width or self._image:getWidth()
	self.height = height or self._image:getHeight()
end

function Image:update()
	DisplayObject.update( self )
end

function Image:draw()
	love.graphics.draw( self._image, self.x, self.y, math.rad( self.rotation ), self.scaleX, self.scaleY, 0, 0 )
end

function Image:getRawImage()
	return self._image
end

function Image:__tostring()
	return 'Image (' .. src .. '): {' .. tostring( self.x ) .. ', ' .. tostring( self.y ) .. '} sized ' .. tostring( self.width ) .. ', ' .. tostring( self.height )
end
