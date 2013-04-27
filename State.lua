require 'libs/middleclass'

State = class( 'State' )

function State:initialize( name, beetle, signal )
	self.name = name
	self.beetle = beetle
	self.signal = signal

	self.index = 1
end
