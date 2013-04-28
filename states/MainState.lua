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

	self.platforms = {
		Platform:new(  60,  60, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 120, 120, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 180, 180, 60, 30, 'images/platform.png', Platform.BOUNCING, self.world ),
		Platform:new( 240, 240, 60, 30, 'images/platform.png', Platform.BOUNCING, self.world ),
		Platform:new( 300, 300, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 360, 360, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 420, 420, 120, 30, 'images/platform.png', Platform.SLIPPING, self.world ),
		Platform:new( 540, 480, 120, 30, 'images/platform.png', Platform.SLIPPING, self.world ),
		Platform:new( 660, 540, 120, 30, 'images/platform.png', Platform.SLIPPING, self.world )
	}

	self.player = Player:new( 90, 0, 25, nil, self.world )

	leftEdge = {}
	leftEdge.b = love.physics.newBody( self.world, 0, 0, 'static' )
	leftEdge.s = love.physics.newEdgeShape( 0, 0, 0, 600 );
	leftEdge.f = love.physics.newFixture( leftEdge.b, leftEdge.s, 100 )

	rightEdge = {}
	rightEdge.b = love.physics.newBody( self.world, 800, 0, 'static' )
	rightEdge.s = love.physics.newEdgeShape( 0, 0, 0, 600 );
	rightEdge.f = love.physics.newFixture( rightEdge.b, rightEdge.s, 100 )

	bottomEdge = {}
	bottomEdge.b = love.physics.newBody( self.world, 0, 600, 'static' )
	bottomEdge.s = love.physics.newEdgeShape( 0, 0, 800, 0 );
	bottomEdge.f = love.physics.newFixture( bottomEdge.b, bottomEdge.s, 100 )
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
