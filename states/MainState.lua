require 'libs/middleclass'

require 'view/Image'

require 'State'

MainState = class( 'MainState', State )

function MainState:initialize( name, beetle, signal )
	State.initialize( self, name, beetle, signal )
end

function MainState:init()
	self.background = Image:new( love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5, nil, nil, 'images/background.png' )
end
function MainState:update( dt )
end
function MainState:draw()
	self.background:draw()
end
