require 'libs/middleclass'

require 'states/LevelState'

LevelThreeState = class( 'LevelThreeState', LevelState )

function LevelThreeState:initialize( name, beetle, signal )
	LevelState.initialize( self, name, beetle, signal )
end

function LevelThreeState:init()
	LevelState.init( self )

	local scH = love.graphics.getHeight()
	local scW = love.graphics.getWidth()
	local halfScW = scW / 2
	local halfScH = scH / 2

	self:addPlatform( halfScW - 60, scH - 100, Platform.MOVING_H )
	self:addPlatform( 0, scH - 200, Platform.STATIC, 60 )
	self:addPlatform( scW - 60, scH - 200, Platform.STATIC, 60 )
	self:addPlatform( halfScW + 90, scH - 300, Platform.MOVING_V, 90 )
	self:addPlatform( halfScW - 180, scH - 300, Platform.MOVING_V, 90 )
	self:addPlatform( halfScW - 60, scH - 555, Platform.ENDING )
end

function LevelThreeState:enter()
	LevelState.enter( self )
	
	self.signal.emit( 'set_target', State.LEVEL_FOUR )
end
