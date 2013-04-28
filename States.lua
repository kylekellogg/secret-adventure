require 'libs/middleclass'

States = class( 'States' )

States.static.states = {}

function States:initialize()
end

function States.static:add( t )
	t.index = table.getn( States.states ) + 1
	table.insert( States.states, t )
end

function States.static:get( name )
	for i,v in pairs(States.states) do
		if v.name == name then
			do return v end
		end
	end
end
