require 'libs/middleclass'

require 'view/Image'
require 'view/Animation'
require 'view/Splatter'

require 'states/State'

TestState = class( 'TestState', State )

function TestState:initialize( name, beetle, signal )
	State.initialize( self, name, beetle, signal )
end

--	Called only once
function TestState:init()
	self.background = Image:new( 0, 0, nil, nil, 'images/background.png' )
	self.splatter = Splatter:new()
	self.test = Animation:new( love.graphics.getWidth() * 0.5 - 48, love.graphics.getHeight() * 0.5 - 48, nil, nil, 'images/explosion.png', 96, 96, Animation.DEFAULT_FPS )
	self.test:setMode( Animation.LOOP )
	self.splatterDebug = self.beetle.add( 'splatters', 0 )
end

--	Called every time switch()ing to state
function TestState:enter( previous )
	--	
end

--	Called every time switch()ing away from state
function TestState:leave()
	-- 
end

function TestState:update( dt )
	self.test:update( dt )
end

function TestState:draw()
	self.background:draw()
	self.splatter:draw()
	self.test:draw()
end

function TestState:mousepressed( x, y, button )
	if button == 'l' then
		local w = math.random( 100 )
		local h = math.random( 100 )
		self.splatter:add( x, y, w, h )
		self.beetle.update( self.splatterDebug, table.getn( self.splatter.splats ) )
	end
end

function TestState:keyreleased( key )
	if key == 'm' then
		self.signal.emit( 'set_state', State.MAIN )
	end

	if ( key == '1' ) then
		self.signal.emit( 'set_state', State.LEVEL_ONE )
	end
end
