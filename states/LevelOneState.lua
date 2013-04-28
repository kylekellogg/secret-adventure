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

	self.platforms = {
		Platform:new( ( love.graphics.getWidth() / 2 ) - 50, love.graphics.getHeight() - 100, 100, 25, 'images/platform.png' ),
		Platform:new( ( love.graphics.getWidth() / 2 ) + 100, love.graphics.getHeight() - 200, 100, 25, 'images/platform.png' ),
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
	for _,p in pairs(self.platforms) do
		p:update( dt )
	end
end

function LevelOneState:draw()
  LevelState:draw()

	for _,p in pairs(self.platforms) do
		p:draw()
	end
end
