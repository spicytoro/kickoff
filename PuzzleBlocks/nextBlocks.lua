------------
-- Locals -- 
------------
local nextSquare = require( "nextSquare" )
local nextBlocks = {}
local nextBlocks_mt = { __index = nextBlocks }
local W = display.contentWidth
local H = display.contentHeight
-----------------
-- Constructor --
-----------------

function nextBlocks.new(  )
	local nextBlocks = {}

	local nextBlocks = {}
	
	local x = W/2
	local y = H-130
	local spacing = 48
	local size = 44
	for j=1, 7 do
		nextBlocks[j] = nextSquare.new(j, x - (3*spacing) + spacing*(j-1), y, size, size)
	end
	return setmetatable( nextBlocks, nextBlocks_mt )
end

-------------
-- Methods -- 
-------------

function nextBlocks:toColor( )
	for i=1,_waveNumber do
		self[i]:toColor()
	end
	
end

return nextBlocks