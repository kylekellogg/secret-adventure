require 'libs/middleclass'

require 'view/Image'
require 'view/Platform'

require 'states/LevelState'

LevelFourState = class( "LevelFourState", LevelState )

local Signal
local override = false

function LevelFourState:initialize( name, beetle, signal )
  LevelState.initialize( self, name, beetle, signal )

	Signal = signal
end

--	Called only once
function LevelFourState:init()
  LevelState:init()

  local scW = love.graphics.getWidth()
  local scH = love.graphics.getHeight()
  local halfScW = scW / 2
  local halfScH = scH / 2

	self.platforms = {
    Platform:new( halfScW - 30, scH - 105, Platform.STATIC, self.world, 60 ),
    Platform:new( halfScW - 30, scH - 210, Platform.STATIC, self.world, 60 ),
    Platform:new( halfScW - 30, scH - 315, Platform.STATIC, self.world, 60 ),
    Platform:new( halfScW + 90, scH - 420, Platform.MOVING_H, self.world, 90 ),
    Platform:new( halfScW - 180, scH - 420, Platform.MOVING_H, self.world, 90 ),
    Platform:new( 0, scH - 520, Platform.STATIC, self.world, 60 ),
    Platform:new( scW - 60, scH - 520, Platform.STATIC, self.world, 60 ),
    Platform:new( halfScW + 90, scH - 620, Platform.MOVING_V, self.world, 90 ),
    Platform:new( halfScW - 180, scH - 620, Platform.MOVING_V, self.world, 90 ),
    Platform:new( 0, scH - 875, Platform.STATIC, self.world ),
    Platform:new( scW - 120, scH - 875, Platform.STATIC, self.world ),
    Platform:new( halfScW - 60, scH - 975, Platform.ENDING, self.world ),
	}
end

--	Called every time switch()ing to state
function LevelFourState:enter( previous )
	--	
end

--	Called every time switch()ing away from state
function LevelFourState:leave()
	-- 
end

function LevelFourState:update( dt )
  LevelState:update( dt )
	self.world:update( dt )
end

function LevelFourState:draw()
	for _,p in pairs(self.platforms) do
		p:draw()
	end

  LevelState:draw()
end

function LevelFourState:keypressed( key )
  LevelState.keypressed( self, key )

	if ( key == 'i' ) then
    self:cameraUp()
	end

	if ( key == 'k' ) then
    self:cameraDown()
	end
end

function LevelFourState:cameraUp()
  for _,p in pairs(self.platforms) do
    p.body:setY(p.body:getY() + 10)
  end
end

function LevelFourState:cameraDown()
  for _,p in pairs(self.platforms) do
    p.body:setY(p.body:getY() - 10)
  end
end
