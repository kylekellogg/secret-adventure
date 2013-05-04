require 'libs/middleclass'

require 'view/Platform'
require 'view/Player'

State = class( 'State' )

local Signal
local Beetle
local override = false
local grounded = false
local target
local removeCallbacks = false
local destroyWorld = false

State.static.TEST = 'test'
State.static.MAIN = 'main'
State.static.LEVEL_ONE = 'levelOne'
State.static.LEVEL_TWO = 'levelTwo'
State.static.LEVEL_THREE = 'levelThree'
State.static.LEVEL_FOUR = 'levelFour'

function State:initialize( name, beetle, signal )
	self.name = name
	self.beetle = beetle
	self.signal = signal

	self.platforms = {}

	self.startPosition = {
		x = love.graphics.getWidth() * 0.5,
		y = love.graphics.getHeight() * 0.5
	}

	self.index = 1

	target = State.MAIN

	self.signal.register( 'set_target', function( t )
		if target == t then return end
		target = t
	end )

	Signal = signal
	Beetle = beetle
end

function State:update( dt )
	if self.world == nil then return end

	if removeCallbacks then
		removeCallbacks = false
		self:removeWorldCallbacks()
		self.signal.emit( 'set_state', target )
	end

	if destroyWorld then
		self:generateWorld()
		return
	end
	self.world:update( dt )

	for _,p in pairs(self.platforms) do
		p:update( dt )
	end

	if self.player == nil then return end

	if love.keyboard.isDown( 'w' ) or love.keyboard.isDown( 'up' ) then
		self.signal.emit( 'player_jump', override, grounded )
		override = false
		grounded = false
	end

	self.player:update( dt )
end

function State:draw()
	if self.world:isLocked() or destroyWorld then
		destroyWorld = false
		return
	else
		for _,p in pairs(self.platforms) do
			p:draw()
		end

		self.player:draw()
	end
end

function State:keypressed( key )
	if key == 'r' then
		self:placePlayer( self.startPosition.x, self.startPosition.y )
	end
end

--	Gamestate stuff

function State:init()
	self:generateWorld()
end

function State:enter()
	destroyWorld = true
end

function State:leave()
	for i in pairs(self.platforms) do
		self.platforms[i] = nil
	end
end

--	Helpers

function State:removeWorldCallbacks()
	self.world:setCallbacks( nil, nil, nil, nil )
end

function State:addWorldCallbacks()
	self.world:setCallbacks( self.beginContact, self.endContact, self.preSolve, self.postSolve )
end

function State:generateWorld( xgrav, ygrav, sleep )
	if self.world ~= nil then
		self.player:destroy()
		self.world:destroy()
		self.world  = nil
		self.leftEdge = nil
		self.rightEdge = nil
		self.bottomEdge = nil
		self.player = nil
	end

	self.world = love.physics.newWorld( xgrav or 0, ygrav or (9.81 * 60), sleep or true )
	self:addWorldCallbacks()

	self:generatePlayer()

	self:generateEdges()

	local oldPlatforms = {}
	for i,p in pairs(self.platforms) do
		oldPlatforms[i] = p
		self.platforms[i] = nil
	end

	for i,p in pairs(oldPlatforms) do
		self:addPlatform( p.x, p.y, p:getMode(), p.width, p.height )
		oldPlatforms[i] = nil
	end
end

function State:generatePlayer( x, y )
	self.player = Player:new( x or self.startPosition.x, y or self.startPosition.y, 25, nil, self.world, self.signal )
end

function State:placePlayer( x, y )
	self.player.body:setPosition( x, y )
end

function State:generateEdges( scale )
	local scaleFactor = scale or 5
	local hscale = scaleFactor - 1

	if self.leftEdge ~= nil and self.leftEdge.f ~= nil then
		self.leftEdge.f:destroy()
	end

	if self.rightEdge ~= nil and self.rightEdge.f ~= nil then
		self.rightEdge.f:destroy()
	end

	if self.bottomEdge ~= nil and self.bottomEdge.f ~= nil then
		self.bottomEdge.f:destroy()
	end

	self.leftEdge = {}
	self.leftEdge.b = love.physics.newBody( self.world, 0, -love.graphics.getHeight() * hscale, 'static' )
	self.leftEdge.s = love.physics.newEdgeShape( 0, 0, 0, love.graphics.getHeight() * scaleFactor )
	self.leftEdge.f = love.physics.newFixture( self.leftEdge.b, self.leftEdge.s, 100 )
	self.leftEdge.f:setUserData( 'left' )

	self.rightEdge = {}
	self.rightEdge.b = love.physics.newBody( self.world, love.graphics.getWidth(), -love.graphics.getHeight() * hscale, 'static' )
	self.rightEdge.s = love.physics.newEdgeShape( 0, 0, 0, love.graphics.getHeight() * scaleFactor )
	self.rightEdge.f = love.physics.newFixture( self.rightEdge.b, self.rightEdge.s, 100 )
	self.rightEdge.f:setUserData( 'right' )

	self.bottomEdge = {}
	self.bottomEdge.b = love.physics.newBody( self.world, 0, love.graphics.getHeight(), 'static' )
	self.bottomEdge.s = love.physics.newEdgeShape( 0, 0, love.graphics.getWidth(), 0 )
	self.bottomEdge.f = love.physics.newFixture( self.bottomEdge.b, self.bottomEdge.s, 100 )
	self.bottomEdge.f:setUserData( 'bottom' )
end

function State:addPlatform( x, y, type, width, height )
	table.insert( self.platforms, Platform:new( x, y, type or Platform.STATIC, self.world, width, height ) )
end

--	Collision detection

function State.beginContact( a, b, coll )
	local atype = a:getUserData()
	local btype = b:getUserData()
	local loseMass = true
	local loseMassMultiplier = 1.0

	grounded = false
	override = false
	Signal.emit( 'reset_player_jump' )
	Signal.emit( 'player_sticking', 0.5 )
	
	if atype == 'left' or atype == 'right' then
		--	
		loseMass = false
	elseif atype == 'bottom' then
		--	
		grounded = true
		loseMass = false
	end

	if atype == 'platform-slipping' or atype == 'platform-moving-h-slipping' or atype == 'platform-moving-v-slipping' then
		override = true
		Signal.emit( 'player_sticking', 0.0 )
	elseif atype == 'platform-sticking' then
		loseMassMultiplier = 1.5
		Signal.emit( 'player_sticking', 1.0 )
	elseif atype == 'platform-bouncing' or atype == 'platform-moving-h-bouncing' or atype == 'platform-moving-v-bouncing' then
		override = true
	elseif atype == 'platform-moving-h' or atype == 'platform-moving-v' then
		override = true
	elseif atype == 'platform-ending' then
		--	Set flag so that, before next world update, callers are removed, the state is switched, and callers are then added again
		removeCallbacks = true
	else
	end

	if loseMass == true then
		Signal.emit( 'player_lose_mass', loseMassMultiplier )
	end
end

function State.endContact( a, b, coll )
end

function State.preSolve( a, b, coll )
	
end

function State.postSolve( a, b, coll )
end
