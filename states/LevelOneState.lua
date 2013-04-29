require 'libs/middleclass'

require 'view/Image'
require 'view/Platform'

require 'states/LevelState'

LevelOneState = class( "LevelOneState", LevelState )

local Signal
local override = false

function LevelOneState:initialize( name, beetle, signal )
  LevelState.initialize( self, name, beetle, signal )

	Signal = signal
end

--	Called only once
function LevelOneState:init()
  LevelState:init()

  self.signal.emit( 'set_target_level', LevelState.LEVEL_TWO )

  local scW = love.graphics.getWidth()
  local scH = love.graphics.getHeight()
  local halfScW = scW / 2
  local halfScH = scH / 2

	self.platforms = {
		Platform:new( halfScW - 60, scH - 100, Platform.STATIC, self.world ),
		Platform:new( halfScW + 90, scH - 200, Platform.STATIC, self.world ),
		Platform:new( halfScW - 180, scH - 300, Platform.ENDING, self.world ),
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
  LevelState:update( dt )
	self.world:update( dt )
end

function LevelOneState:draw()
	for _,p in pairs(self.platforms) do
		p:draw()
	end

  LevelState:draw()
end
