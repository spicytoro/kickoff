------------
-- Locals -- 
------------

local banner = {}
local banner_mt = { __index = banner }

-----------------
-- Constructor --
-----------------

function banner.new( input, inX, inY )
	local banner = {
		group = display.newGroup(),
	}

	local text = display.newText( "+"..input, inX, inY, system.native, 250 );
	text:setFillColor( .45, .45, .45 );
	text.blendMode = "multiply"
	transition.to( text, { time=500, alpha=0, x=inX, y=inY-100, onComplete=banner.group:remove( ) } )
	

	return setmetatable( banner, banner_mt )
end

-------------
-- Methods -- 
-------------



return banner