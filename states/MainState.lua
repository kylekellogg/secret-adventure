require 'libs/middleclass'

require 'view/Image'
require 'view/Platform'

require 'State'

MainState = class( 'MainState', State )

function MainState:initialize( name, beetle, signal )
	State.initialize( self, name, beetle, signal )
end

--	Called only once
function MainState:init()
	self.background = Image:new( 0, 0, nil, nil, 'images/background.png' )
	self.platforms = {
		Platform:new( 50, 15, 100, 30, 'images/platform.png' ),
		Platform:new( 50, 65, 200, 60, 'images/platform.png', Platform.BOUNCING )
	}
end

--	Called every time switch()ing to state
function MainState:enter( previous )
	--	
end

--	Called every time switch()ing away from state
function MainState:leave()
	-- 
end

function MainState:update( dt )
	for _,p in pairs(self.platforms) do
		p:update( dt )
	end
end

function MainState:draw()
	self.background:draw()

	for _,p in pairs(self.platforms) do
		p:draw()
	end
end
