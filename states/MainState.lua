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
		Platform:new( 0, 0, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 60, 60, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 120, 120, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 180, 180, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 240, 240, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 300, 300, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 360, 360, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 420, 420, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 480, 480, 60, 30, 'images/platform.png', Platform.STATIC, self.world )
	}

	self.player = Player:new( 30, 0, 25, nil, self.world )

	leftEdge = {}
	leftEdge.b = love.physics.newBody( self.world, 0, 0, 'static' )
	leftEdge.s = love.physics.newEdgeShape( 0, 0, 0, 600 );
	leftEdge.f = love.physics.newFixture( leftEdge.b, leftEdge.s )

	rightEdge = {}
	rightEdge.b = love.physics.newBody( self.world, 400, 0, 'static' )
	rightEdge.s = love.physics.newEdgeShape( 400, 0, 400, 600 );
	rightEdge.f = love.physics.newFixture( rightEdge.b, rightEdge.s )

	bottomEdge = {}
	bottomEdge.b = love.physics.newBody( self.world, 0, 300, 'static' )
	bottomEdge.s = love.physics.newEdgeShape( 0, 300, 800, 300 );
	bottomEdge.f = love.physics.newFixture( bottomEdge.b, bottomEdge.s )
end

--	Called every time switch()ing to state
function MainState:enter( previous )
	self.player.body:applyForce( 50, 0 )
end

--	Called every time switch()ing away from state
function MainState:leave()
	-- 
end

function MainState:update( dt )
	self.world:update( dt )

	--for _,p in pairs(self.platforms) do
	--	p:update( dt )
	--end
end

function MainState:draw()
	--self.background:draw()

	for _,p in pairs(self.platforms) do
		p:draw()
	end

	self.player:draw()

	love.graphics.setColor( 0, 255, 0 )
	love.graphics.line( leftEdge.b:getWorldPoints( leftEdge.s:getPoints() ) )
	love.graphics.setColor( 0, 0, 255 )
	love.graphics.line( rightEdge.b:getWorldPoints( rightEdge.s:getPoints() ) )
	love.graphics.setColor( 255, 0, 0 )
	love.graphics.line( bottomEdge.b:getWorldPoints( bottomEdge.s:getPoints() ) )
end
