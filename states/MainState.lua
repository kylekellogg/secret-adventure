require 'libs/middleclass'

require 'view/Image'
require 'view/Platform'
require 'view/Player'

require 'State'

MainState = class( 'MainState', State )

function MainState:initialize( name, beetle, signal )
	State.initialize( self, name, beetle, signal )
end

--	Called only once
function MainState:init()
	self.background = Image:new( 0, 0, nil, nil, 'images/background.png' )

	love.physics.setMeter( 60 )
	self.world = love.physics.newWorld( 0, 9.81 * 60, true )

	self.platforms = {
		Platform:new( 60, 60, 60, 60, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 60, 120, 120, 120, 'images/platform.png', Platform.STATIC, self.world )
	}

	self.player = Player:new( 60, 0, 25, nil, self.world )
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
	self.world:update( dt )

	--for _,p in pairs(self.platforms) do
	--	p:update( dt )
	--end
end

function MainState:draw()
	--self.background:draw()

	for _,p in pairs(self.platforms) do
		p:draw()
	end

	self.player:draw()
end
