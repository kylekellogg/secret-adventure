require 'libs/middleclass'

require 'view/Image'
require 'view/Platform'

require 'State'

LevelState = class( "LevelState", State )

function LevelState:initialize( name, beetle, signal )
  State.initialize( self, name, beetle, signal )
end

--	Called only once
function LevelState:init()
	self.background = Image:new( 0, 0, nil, nil, 'images/background.png' )
end

--	Called every time switch()ing to state
function LevelState:enter( previous )
	--	
end

--	Called every time switch()ing away from state
function LevelState:leave()
	-- 
end

function LevelState:draw()
end
