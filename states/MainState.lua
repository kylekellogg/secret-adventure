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

	love.physics.setMeter( 30 )
	self.world = love.physics.newWorld( 0, 9.81 * 60, true )

	self.platforms = {
		Platform:new( 0, 30, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 60, 90, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 120, 150, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 180, 210, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 240, 270, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 300, 330, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 360, 390, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 420, 450, 60, 30, 'images/platform.png', Platform.STATIC, self.world ),
		Platform:new( 480, 510, 60, 30, 'images/platform.png', Platform.STATIC, self.world )
	}

	self.player = Player:new( 30, 0, 25, nil, self.world )
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
end
