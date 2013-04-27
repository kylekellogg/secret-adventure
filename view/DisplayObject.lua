require 'libs/middleclass'

DisplayObject = class( 'DisplayObject' )

function DisplayObject:initialize( x, y, width, height )
	self.x = x
	self.y = y
	self.width = width
	self.heigh = height

	self.rotation = 0
	self.scaleX = 1
	self.scaleY = 1
end

function DisplayObject:update()
	--	Update
end

function DisplayObject:draw()
	--	Draw
end

function DisplayObject:scale( val )
	self.scaleX = val
	self.scaleY = val
end

function DisplayObject:__tostring()
	return 'DisplayObject: {' .. tostring( self.x ) .. ', ' .. tostring( self.y ) .. '} sized ' .. tostring( self.width ) .. ', ' .. tostring( self.height )
end
