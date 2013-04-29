require 'libs/middleclass'

require 'view/Image'
require 'view/Platform'

require 'State'

LevelState = class( "LevelState", State )

LevelState.static.LEVEL_ONE = 'one'
LevelState.static.LEVEL_TWO = 'two'
LevelState.static.LEVEL_THREE = 'three'
LevelState.static.LEVEL_FOUR = 'four'

local Signal
local override = false

local target

function LevelState:initialize( name, beetle, signal )
 	State.initialize( self, name, beetle, signal )

	Signal = signal
end

--	Called only once
function LevelState:init()
	local scW = love.graphics.getWidth()
	local scH = love.graphics.getHeight()
	local halfScW = scW / 2
	local halfScH = scH / 2

	self.world = love.physics.newWorld( 0, 9.81 * 60, true )
	self.world:setCallbacks( self.beginContact, self.endContact, self.preSolve, self.postSolve )
	self.player = Player:new( halfScW - (25/2), scH - (25/2), 25, nil, self.world, Signal )

	leftEdge = {}
	leftEdge.b = love.physics.newBody( self.world, 0, -love.graphics.getHeight(), 'static' )
	leftEdge.s = love.physics.newEdgeShape( 0, 0, 0, love.graphics.getHeight() * 2 );
	leftEdge.f = love.physics.newFixture( leftEdge.b, leftEdge.s, 100 )
	leftEdge.f:setUserData( 'left' )

	rightEdge = {}
	rightEdge.b = love.physics.newBody( self.world, love.graphics.getWidth(), -love.graphics.getHeight(), 'static' )
	rightEdge.s = love.physics.newEdgeShape( 0, 0, 0, love.graphics.getHeight() * 2 );
	rightEdge.f = love.physics.newFixture( rightEdge.b, rightEdge.s, 100 )
	rightEdge.f:setUserData( 'right' )

	bottomEdge = {}
	bottomEdge.b = love.physics.newBody( self.world, 0, love.graphics.getHeight(), 'static' )
	bottomEdge.s = love.physics.newEdgeShape( 0, 0, love.graphics.getWidth(), 0 );
	bottomEdge.f = love.physics.newFixture( bottomEdge.b, bottomEdge.s, 100 )
	bottomEdge.f:setUserData( 'bottom' )

	target = LevelState.LEVEL_ONE

	Signal.register( 'set_target_level', function( t ) target = t end )
end

--	Called every time switch()ing to state
function LevelState:enter( previous )
	--	
end

--	Called every time switch()ing away from state
function LevelState:leave()
	-- 
end

function LevelState:update( dt )
	self.player:update( dt )
end

function LevelState:draw()
	self.player:draw()
end

function LevelState:keypressed( key )
	if key == 'w' or key == 'up' then
		self.signal.emit( 'player_jump', override )
		override = false
	end

	if key == 'r' then
		self.player.body:setPosition( 90, 0 )
	end

	if ( key == '1' ) then
		self.signal.emit( 'switch_to_level_one' )
	end

	if ( key == '2' ) then
		self.signal.emit( 'switch_to_level_two' )
	end

	if ( key == '3' ) then
		self.signal.emit( 'switch_to_level_three' )
	end

	if ( key == '4' ) then
		self.signal.emit( 'switch_to_level_four' )
	end
end

function LevelState.beginContact( a, b, coll )
	local atype = a:getUserData()
	local abody = a:getBody()
	local btype = b:getUserData()
	local bbody = b:getBody()
	local x, y

	override = false
	Signal.emit( 'reset_player_jump' )
	
	if atype == 'left' or atype == 'right' then
		--	
	elseif atype == 'bottom' then
		--	
	end

	if atype == 'platform-slipping' or atype == 'platform-moving-h-slipping' or atype == 'platform-moving-v-slipping' then
		x, y = bbody:getLinearVelocity()
		if x > 0 then
			x = math.min( x * 1.5, 100 )
		elseif x < 0 then
			x = math.max( x * 1.5, -100 )
		end
		bbody:applyLinearImpulse( x, 0 )
	elseif atype == 'platform-sticking' then
		x, y = bbody:getLinearVelocity()
		if x > 0 then
			x = math.max( x * 0.5, 5 )
		elseif x < 0 then
			x = math.min( x * 0.5, -5 )
		end
		bbody:applyLinearImpulse( x * 0.5, 0 )
	elseif atype == 'platform-bouncing' or atype == 'platform-moving-h-bouncing' or atype == 'platform-moving-v-bouncing' then
		override = true
	elseif atype == 'platform-ending' then
		print( 'target? ' .. target )
		Signal.emit( 'switch_to_level_' .. target )
	else
	end
end

function LevelState.endContact( a, b, coll )
end

function LevelState.preSolve( a, b, coll )
	
end

function LevelState.postSolve( a, b, coll )
end
