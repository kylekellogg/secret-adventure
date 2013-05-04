require 'libs/middleclass'

require 'view/Image'
require 'view/Platform'

require 'states/LevelState'

LevelTwoState = class( 'LevelTwoState', LevelState )

function LevelTwoState:initialize( name, beetle, signal )
	LevelState.initialize( self, name, beetle, signal )
end

function LevelTwoState:init()
	LevelState.init( self )

	local scH = love.graphics.getHeight()
	local scW = love.graphics.getWidth()
	local halfScW = scW / 2
	local halfScH = scH / 2

	self:addPlatform( halfScW - 240, scH - 100, Platform.STATIC )
    self:addPlatform( halfScW + 120, scH - 100, Platform.STATIC )
    self:addPlatform( halfScW - 60, scH - 205, Platform.STATIC )
    self:addPlatform( halfScW + 120, scH - 305, Platform.STATIC )
    self:addPlatform( halfScW + 120, scH - 405, Platform.STATIC )
    self:addPlatform( halfScW + 120, scH - 505, Platform.ENDING )
end

function LevelTwoState:enter()
	LevelState.enter( self )

	self.signal.emit( 'set_target', State.LEVEL_THREE )
end
