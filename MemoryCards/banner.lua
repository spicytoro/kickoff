------------
-- Locals -- 
------------

local banner = {}
local banner_mt = { __index = banner }

-----------------
-- Constructor --
-----------------

function banner.new( options )
	local banner = {
		group = display.newGroup(),
	}

	local text = display.newText( options.text, options.inX, options.inY, system.native, 50 );

	transition.to( text, { time=options.time, alpha=0, x=options.toX, y=options.toY, onComplete=banner.group:remove( ) } )
	text:setFillColor( 0, 1, 0 );



	return setmetatable( banner, banner_mt )
end

-------------
-- Methods -- 
-------------



return banner