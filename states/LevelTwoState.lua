require 'libs/middleclass'

require 'view/Image'
require 'view/Platform'

require 'states/LevelState'

LevelTwoState = class( "LevelTwoState", LevelState )

local Signal
local override = false

function LevelTwoState:initialize( name, beetle, signal )
  LevelState.initialize( self, name, beetle, signal )

	Signal = signal
end

--	Called only once
function LevelTwoState:init()
  LevelState:init()

  self.signal.emit( 'set_target_level', LevelState.LEVEL_THREE )

  local scW = love.graphics.getWidth()
  local scH = love.graphics.getHeight()
  local halfScW = scW / 2
  local halfScH = scH / 2

	self.platforms = {
    Platform:new( halfScW - 240, scH - 100, Platform.STATIC, self.world ),
    Platform:new( halfScW + 120, scH - 100, Platform.STATIC, self.world ),
    Platform:new( halfScW - 60, scH - 205, Platform.STATIC, self.world ),
    Platform:new( halfScW + 120, scH - 305, Platform.STATIC, self.world ),
    Platform:new( halfScW + 120, scH - 405, Platform.STATIC, self.world ),
    Platform:new( halfScW + 120, scH - 505, Platform.ENDING, self.world ),
	}
end

--	Called every time switch()ing to state
function LevelTwoState:enter( previous )
	--	
end

--	Called every time switch()ing away from state
function LevelTwoState:leave()
	-- 
end

function LevelTwoState:update( dt )
  LevelState:update( dt )
	self.world:update( dt )
end

function LevelTwoState:draw()
	for _,p in pairs(self.platforms) do
		p:draw()
	end

  LevelState:draw()
end
