require 'libs/middleclass'

require 'view/Image'
require 'view/Platform'
require 'view/Player'

require 'State'

MainState = class( 'MainState', State )

function MainState:initialize( name, beetle, signal )
	State.initialize( self, name, beetle, signal )
end

--	Called only once
function MainState:init()
	self.background = Image:new( 0, 0, nil, nil, 'images/background.png' )

	--love.physics.setMeter( 30 )
	self.world = love.physics.newWorld( 0, 9.81 * 60, true )
	self.world:setCallbacks( self.beginContact, self.endContact, self.preSolve, self.postSolve )

	self.platforms = {
		Platform:new(  0,  60, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 60, 120, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 120, 180, 60, 30, 'images/platform.png', Platform.BOUNCING, self.world ),
		Platform:new( 180, 240, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 240, 300, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 300, 360, 120, 30, 'images/platform.png', Platform.SLIPPING, self.world ),
		Platform:new( 420, 420, 120, 30, 'images/platform.png', Platform.SLIPPING, self.world ),
		Platform:new( 480, 540, 120, 30, 'images/platform.png', Platform.STICKING, self.world )
	}

	self.player = Player:new( 90, 0, 25, nil, self.world )

	leftEdge = {}
	leftEdge.b = love.physics.newBody( self.world, 0, 0, 'static' )
	leftEdge.s = love.physics.newEdgeShape( 0, 0, 0, love.graphics.getHeight() );
	leftEdge.f = love.physics.newFixture( leftEdge.b, leftEdge.s, 100 )
	leftEdge.f:setUserData( 'left' )

	rightEdge = {}
	rightEdge.b = love.physics.newBody( self.world, love.graphics.getWidth(), 0, 'static' )
	rightEdge.s = love.physics.newEdgeShape( 0, 0, 0, love.graphics.getHeight() );
	rightEdge.f = love.physics.newFixture( rightEdge.b, rightEdge.s, 100 )
	rightEdge.f:setUserData( 'right' )

	bottomEdge = {}
	bottomEdge.b = love.physics.newBody( self.world, 0, love.graphics.getHeight(), 'static' )
	bottomEdge.s = love.physics.newEdgeShape( 0, 0, love.graphics.getWidth(), 0 );
	bottomEdge.f = love.physics.newFixture( bottomEdge.b, bottomEdge.s, 100 )
	bottomEdge.f:setUserData( 'bottom' )
end

--	Called every time switch()ing to state
function MainState:enter( previous )
	self.player.body:applyForce( 1000, -20000 )
end

--	Called every time switch()ing away from state
function MainState:leave()
	-- 
end

function MainState:update( dt )
	self.world:update( dt )
end

function MainState:draw()
	for _,p in pairs(self.platforms) do
		p:draw()
	end

	self.player:draw()
end

function MainState.beginContact( a, b, coll )
	local atype = a:getUserData()
	local abody = a:getBody()
	local btype = b:getUserData()
	local bbody = b:getBody()
	local x, y
	
	if atype == 'left' or atype == 'right' then
		--	
	elseif atype == 'bottom' then
		--	
	end

	if atype == 'platform-slipping' or atype == 'platform-moving-h-slipping' or atype == 'platform-moving-v-slipping' then
		x, y = bbody:getLinearVelocity()
		print( 'linear velocity: ' .. x .. ', ' .. y )
		if x > 0 then
			x = math.min( x * 1.5, 100 )
		elseif x < 0 then
			x = math.max( x * 1.5, -100 )
		end
		bbody:applyLinearImpulse( x, 0 )
	elseif atype == 'platform-sticking' then
		x, y = bbody:getLinearVelocity()
		print( 'linear velocity: ' .. x .. ', ' .. y )
		if x > 0 then
			x = math.max( x * 0.5, 5 )
		elseif x < 0 then
			x = math.min( x * 0.5, -5 )
		end
		bbody:applyForce( x * 0.5, 0 )
	else
	end
end

function MainState.endContact( a, b, coll )
	
end

function MainState.preSolve( a, b, coll )
	
end

function MainState.postSolve( a, b, coll )
end
