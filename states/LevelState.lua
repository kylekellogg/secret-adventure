require 'libs/middleclass'

require 'states/State'

LevelState = class( 'LevelState', State )

function LevelState:initialize( name, beetle, signal )
 	State.initialize( self, name, beetle, signal )
end

--	Called only once
function LevelState:init()
	State.init( self )
end
