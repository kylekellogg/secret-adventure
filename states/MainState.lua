require 'libs/middleclass'

require 'view/Image'

require 'states/LevelState'

MainState = class( 'MainState', LevelState )

function MainState:initialize( name, beetle, signal )
	LevelState.initialize( self, name, beetle, signal )
end

--	Called only once
function MainState:init()
	LevelState.init( self )

	self.background = Image:new( 0, 0, nil, nil, 'images/background.png' )

	self:addPlatform(   0,  60, Platform.ENDING )
	self:addPlatform(  60, 120, Platform.STATIC )
	self:addPlatform( 120, 180, Platform.BOUNCING )
	self:addPlatform( 180, 240, Platform.STATIC )
	self:addPlatform( 240, 300, Platform.STATIC )
	self:addPlatform( 300, 360, Platform.SLIPPING )
	self:addPlatform( 380, 420, Platform.SLIPPING, 80, 30 )
	self:addPlatform( 520, 480, Platform.STATIC, 80, 30 )
	self:addPlatform( 480, 540, Platform.STICKING )
	self:addPlatform( 400, 567, Platform.STATIC, 80, 30 )
	self:addPlatform(   0, 668, Platform.STATIC )
	self:addPlatform( love.graphics.getWidth() * 0.5 - 40, love.graphics.getHeight() - 30, Platform.MOVING_H, 80, 30 )
end

function MainState:enter()
	LevelState.enter( self )

	self.signal.emit( 'set_target', State.LEVEL_ONE )
end
