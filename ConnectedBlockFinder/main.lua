-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local pathFinder = require("pathFinder");
local Node = require("Node");

-- Your code here

local field = {
	{0,1,1,0,1,0,0},
	{1,1,1,1,1,1,1},
	{0,1,0,0,0,1,0},
	{1,1,0,1,0,1,1},
	{0,1,0,1,0,1,0},
	{1,1,0,2,1,1,1},
	{0,1,0,1,0,1,0},
}; 

local finder = pathFinder.new(field);

local seed = Node.new(4, 4)

finder:find(seed); 

while (#finder.stack > 0) do 
	local yip = finder.stack:pop()
	print( yip[1], yip[2] )
end