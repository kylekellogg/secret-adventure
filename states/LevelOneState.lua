require 'libs/middleclass'

require 'states/LevelState'

LevelOneState = class( 'LevelOneState', LevelState )

function LevelOneState:initialize( name, beetle, signal )
	LevelState.initialize( self, name, beetle, signal )
end

function LevelOneState:init()
	LevelState.init( self )

	local scH = love.graphics.getHeight()
	local scW = love.graphics.getWidth()
	local halfScW = scW / 2
	local halfScH = scH / 2

	self:addPlatform( halfScW - 60, scH - 100, Platform.STATIC )
	self:addPlatform( halfScW + 90, scH - 200, Platform.STATIC )
	self:addPlatform( halfScW - 180, scH - 300, Platform.ENDING )
end

function LevelOneState:enter()
	LevelState.enter( self )

	self.signal.emit( 'set_target', State.LEVEL_TWO )
end
