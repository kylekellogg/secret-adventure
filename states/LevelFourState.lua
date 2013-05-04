require 'libs/middleclass'

require 'states/LevelState'

LevelFourState = class( 'LevelFourState', LevelState )

function LevelFourState:initialize( name, beetle, signal )
	LevelState.initialize( self, name, beetle, signal )
end

function LevelFourState:init()
	LevelState.init( self )

	local scH = love.graphics.getHeight()
	local scW = love.graphics.getWidth()
	local halfScW = scW / 2
	local halfScH = scH / 2

	self:addPlatform( halfScW - 30, scH - 105, Platform.STATIC, 60 )
	self:addPlatform( halfScW - 30, scH - 210, Platform.STATIC, 60 )
	self:addPlatform( halfScW - 30, scH - 315, Platform.STATIC, 60 )
	self:addPlatform( halfScW + 90, scH - 420, Platform.MOVING_H, 90 )
	self:addPlatform( halfScW - 180, scH - 420, Platform.MOVING_H, 90 )
	self:addPlatform( 0, scH - 520, Platform.STATIC, 60 )
	self:addPlatform( scW - 60, scH - 520, Platform.STATIC, 60 )
	self:addPlatform( halfScW + 90, scH - 620, Platform.MOVING_V, 90 )
	self:addPlatform( halfScW - 180, scH - 620, Platform.MOVING_V, 90 )
	self:addPlatform( 0, scH - 875, Platform.STATIC )
	self:addPlatform( scW - 120, scH - 875, Platform.STATIC )
	self:addPlatform( halfScW - 60, scH - 975, Platform.ENDING )
end

function LevelFourState:enter()
	LevelState.enter( self )
	
	self.signal.emit( 'set_target', State.TEST )
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
