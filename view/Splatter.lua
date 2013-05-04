require 'libs/middleclass'

Splatter = class( 'Splatter' )

local splatters = love.graphics.newImage('images/splatters.png')
local splatterSize = {width=300,height=250}
local splattersAvail = splatters:getWidth() / splatterSize.width
local quads = {
    love.graphics.newQuad(0, 0, splatterSize.width, splatterSize.height, splatters:getWidth(), splatters:getHeight()),
    love.graphics.newQuad(splatterSize.width, 0, splatterSize.width, splatterSize.height, splatters:getWidth(), splatters:getHeight()),
    love.graphics.newQuad(splatterSize.width * 2, 0, splatterSize.width, splatterSize.height, splatters:getWidth(), splatters:getHeight()),
}

function Splatter:initialize()
	self.splats = {}
	self.stencils = {
		game = function()
			love.graphics.rectangle( 'fill',
									  0,
									  0,
									  800,
									  600 )
		end
	}
end

function Splatter:draw()
	love.graphics.setColor( 255, 255, 255, 255 )
	love.graphics.setStencil( self.stencils.game )
	for _,s in pairs( self.splats ) do
        love.graphics.drawq( splatters,
                             quads[ s.index ],
                             ( s.position.x + s.width / 2 ) - splatterSize.width / 2 + ( s.flipX and splatterSize.width or 0 ),
                             ( s.position.y + s.height / 2 ) - splatterSize.height / 2 + ( s.flipY and splatterSize.height or 0 ),
                             0,
                             s.flipX and -1 or 1,
                             s.flipY and -1 or 1 )
    end

    love.graphics.setStencil()
end

function Splatter:add(x,y,width,height)
    table.insert( self.splats, {
        position = {
            x = x,
            y = y
        },
        width = width,
        height = height,
        index = math.random( splattersAvail ),
        flipX = math.random( 2 ) == 1,
        flipY = math.random( 2 ) == 1
    } )
end
