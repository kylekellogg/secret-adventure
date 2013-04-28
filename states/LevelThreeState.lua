require 'libs/middleclass'

require 'view/Image'
require 'view/Platform'

require 'states/LevelState'

LevelThreeState = class( "LevelThreeState", LevelState )

local Signal
local override = false

function LevelThreeState:initialize( name, beetle, signal )
  LevelState.initialize( self, name, beetle, signal )

	Signal = signal
end

--	Called only once
function LevelThreeState:init()
  LevelState:init()

  local scW = love.graphics.getWidth()
  local scH = love.graphics.getHeight()
  local halfScW = scW / 2
  local halfScH = scH / 2

	self.platforms = {
    Platform:new( halfScW - 60, scH - 100, Platform.MOVING_H, self.world ),
    Platform:new( 0, scH - 200, Platform.STATIC, self.world, 60 ),
    Platform:new( scW - 60, scH - 200, Platform.STATIC, self.world, 60 ),
    Platform:new( halfScW + 90, scH - 300, Platform.MOVING_V, self.world, 90 ),
    Platform:new( halfScW - 180, scH - 300, Platform.MOVING_V, self.world, 90 ),
    Platform:new( halfScW - 60, scH - 555, Platform.ENDING, self.world ),
	}
end

--	Called every time switch()ing to state
function LevelThreeState:enter( previous )
	--	
end

--	Called every time switch()ing away from state
function LevelThreeState:leave()
	-- 
end

function LevelThreeState:update( dt )
  LevelState:update( dt )
	self.world:update( dt )
end

function LevelThreeState:draw()
	for _,p in pairs(self.platforms) do
		p:draw()
	end

  LevelState:draw()
end
