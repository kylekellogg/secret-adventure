require 'libs/middleclass'

require 'view/Image'
require 'view/Platform'

require 'states/LevelState'

LevelOneState = class( "LevelOneState", LevelState )

function LevelOneState:initialize( name, beetle, signal )
  LevelState.initialize( self, name, beetle, signal )
end

--	Called only once
function LevelOneState:init()
  LevelState:init()

	love.physics.setMeter( 60 )
	self.world = love.physics.newWorld( 0, 9.81 * 60, true )

	self.platforms = {
		Platform:new( 0, 0, 100, 25, 'images/platform.png', Platform.STATIC, self.world )
	}
end

--	Called every time switch()ing to state
function LevelOneState:enter( previous )
	--	
end

--	Called every time switch()ing away from state
function LevelOneState:leave()
	-- 
end

function LevelOneState:update( dt )
	self.world:update( dt )
	--for _,p in pairs(self.platforms) do
		--p:update( dt )
	--end
end

function LevelOneState:draw()
  LevelState:draw()

	for _,p in pairs(self.platforms) do
		p:draw()
	end
end
