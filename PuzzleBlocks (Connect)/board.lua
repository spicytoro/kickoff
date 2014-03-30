------------
-- Locals -- 
------------
local board = {}
local board_mt = { __index = board }
local W, H = display.contentWidth, display.contentHeight
-- local stack = require("stack")
local square = require("square")
local stack = require("stack")
local banner = require("banner")
local pathFinder = require("pathFinder")
local ScoreKeeper = require( "ScoreKeeper" )
local ScoreKeeper = ScoreKeeper.new("score")

-----------------
-- Constructor --
-----------------

function board.new(  )
	local board = {
		{0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0},
		paint = {{},{},{},{},{},{},{}},
		finder = nil
	}
	
	local map = {{},{},{},{},{},{},{}}

	local x = W/2
	local y = H/2
	local spacing = 90
	local size = 88
	
	for i=1, 7 do
		for j=1, 7 do
			map[i][j] = board[i][j];
			board.paint[i][j] = square.new( x - (3*spacing) + spacing*(j-1), y - (3*spacing) + spacing*(i-1), size, size, i, j)
			board.paint[i][j]:setColor(0)
		end
	end

	board.finder = pathFinder.new(map); 

	return setmetatable( board, board_mt )
	
end

---------------------
-- Local Functions -- 
---------------------


local function randomPoint()
	local point = {
		x = math.random(1,7),
		y = math.random(1,7),
		c = math.random(1,5)
	}
	return point
end


local function printPoint( point )
	print( "(" .. point.x .. ", " .. point.y .. ") c: " .. point.c )
end

local function updateCount( input )
	input.count = 0
	for i=1, 7 do
		for j=1, 7 do
			if (input.paint[i][j].index ~= 0) then
				input.count = input.count + 1
			end
		end
	end
end

-- 0,3,3,3,3,8,9
-------------
-- Methods -- 
-------------
function board:edgify(  )
	local left = 4-math.floor(_boardH/2)
	local right = 4+math.floor(_boardH/2)
	local up = 4-math.floor(_boardW/2)
	local down = 4+math.floor(_boardW/2)
	print( left, right )
	for i=1,7 do
		for j=1,7 do
			self[i][j] = 0;
			if (i < left or i > right) then
				self[i][j] = -1;
			end
			if (j < up or j > down) then				
				self[i][j] = -1;
			end
		end
	end
	self:updateColor();
end

function board:updatePathFinder( )
	local map = {{},{},{},{},{},{},{}}
	
	for i=1, 7 do
		for j=1, 7 do
			map[i][j] = self[i][j];
		end
	end
	
	self.finder:newMap(map); 

	map = nil; 
end

function board:print(input)

	print( "----flipped---" )
	for i=1, 7 do
		local line = ""
		for j=1, 7 do
			line = line .. self[i][j] .. " "
		end
		print( line )
	end
	print( "-------------" )
end

function board:place(row,col,color)
	self[row][col] = color; 
	self.paint[row][col]:animatePutDown(_squareSize); 
	self:updateColor(); 
end

function board:updateColor(  )
	for i=1,7 do
		for j=1,7 do
			self.paint[i][j]:setColor( self[i][j] )
			self.paint[i][j].color = self[i][j]
		end
	end
end

function board:spotsLeft ()
	local indexW = math.floor(_boardW/2)
	local indexH = math.floor(_boardH/2)
	local spots = 0; 
	for i=4-indexH,4+indexH do
		for j=4-indexW,4+indexW do
			if (self[i][j] == 0) then 
				spots = spots + 1;  
			end
		end
	end
	print( 4-indexH,4+indexH,spots )
	return spots; 
end 

function board:nextWave( squares )
	local indexW = math.floor(_boardW/2)
	local indexH = math.floor(_boardH/2)
	local function placeIt ()
		if (not _gameOver) then
			
			if (self:spotsLeft() > 0) then 
				local row = math.random(4-indexH,4+indexH)
				local col = math.random(4-indexW,4+indexW)

				while (self[row][col] ~= 0 ) do 
					row = math.random(4-indexH,4+indexH)
					col = math.random(4-indexW,4+indexW)
				end
				self:place(row,col,_colors:remove())
				_nextBlocks:toColor()
			--	_nextBlocksTop:toColor()

			--	self:print(  )
			else

			--	print( self.finder:checkMoves() )
			--	_gameOver = not self.finder:checkMoves(); 
			end 
		end
	--	board:removeLines();
	end

	if (self:spotsLeft() <= squares) then
		squares = self:spotsLeft() + 1;
	end
	
	local timerz = timer.performWithDelay( 250, placeIt, squares )

--	local function removeIt(  )
--		self:removeLines()
--	end

--	local remover = timer.performWithDelay( 250*(squares) + 50, removeIt, 1 )
end

function board:squareToWhite(point)
	local row = point[1];
	local col = point[2];
	if (self[row][col] ~= 0) then	
		self.paint[row][col]:animateLine();
		self.paint[row][col].image.alpha = 1; 
		
		local function toWhite(  )
			self[row][col] = 0;
			self:updateColor();
		end

		local timer = timer.performWithDelay( 125, toWhite, 1 )
	end
end

function board:linesToWhite( toDelete )
	print( "test" )
	local len = #toDelete; 	

	local function remove ()
		self:squareToWhite(toDelete:pop())
	end
	if (len > 0) then
		local timer = timer.performWithDelay( 50, remove, len )
	end

	local function timer4(  )
		_doneDeleting = true
	end

	local timer4 = timer.performWithDelay( 50*len + 125, timer4, 1 )
end



function board:removeLines(row, col )
	print( _doneDeleting )
	if (_doneDeleting) then
		 _doneDeleting = false;
		local toDelete = stack.new()

	--[[	-- find lines in rows
		for i=1,7 do
			local stack = board:scanRow(self[i])
			while (#stack ~= 0) do
				toDelete:push({i,stack:pop()})
			end
		end
		-- find lines in cols
		-- flip first
		local flipped = {{},{},{},{},{},{},{}}; 
		for i=1,7 do
			for j=1,7 do
				flipped[j][i] = self[i][j]
			end
		end
		-- find rows in flipped
		for i=1,7 do
			local stack = board:scanRow(flipped[i])
			while (#stack ~= 0) do
				toDelete:push({stack:pop(), i})
			end
		end
	]]--
		----------------------------------------------------
		-- INSERT CALL TO ALTERNATE LINE FINDING ALGORITH -- 
		----------------------------------------------------

		self.finder.stack = nil
		self.finder.stack = stack.new()
		
		self:updatePathFinder();
			
		self.finder:find(row,col); 
		if (#self.finder.stack < 4) then 
			self.finder.stack = nil
			self.finder.stack = stack.new()
		else 
			_noShrink = true; 	
			while (#self.finder.stack > 0) do 
				toDelete:push(self.finder.stack:pop())
			end

		end
		local numBlocks = #toDelete
		-- delete them
		if (numBlocks > 0) then
			_combo = _combo*2
			if (not _added) then
					_pickedUp = nil
					banner.new("+" .. numBlocks*numBlocks*_combo, W/2, H/2 )
					_score = _score + numBlocks*numBlocks*_combo
					
					local function timer3(  )
						banner.new("×".._combo, W/2, H/2 )
					end

				--	if (_combo > 2) then
						local timer3 = timer.performWithDelay( 500, timer3 )
				--	end
						

					ScoreKeeper:update(_score)
					numBlocks = 0; 
				_added = true; 
			end
			_gotLine = true;
			self:linesToWhite(toDelete);
		end
		
	end
end

function board:remove( )

	local row = 1

	function removeBlock(  )
		for i=row,8-row do
			self.paint[row][i]:removeSquare( );
			self.paint[i][row]:removeSquare( );
			self.paint[8-row][8-i]:removeSquare( );
			self.paint[8-i][8-row]:removeSquare( );
		end
		row = row+1
	end
	
	
	local timer = timer.performWithDelay( 100, removeBlock, 4 ) 
end

function board:revive( )
--[[
	local row = 4

	function reviveBlock(  )

		for i=4-(row-4),row do
			_board[row][i] = 0;
			_board[i][row] = 0;
			_board[8-row][8-i] = 0;
			_board[8-i][8-row] = 0;
			_board:updateColor();
			self.paint[row][i]:reviveSquare( );
			self.paint[i][row]:reviveSquare( );
			self.paint[8-row][8-i]:reviveSquare( );
			self.paint[8-i][8-row]:reviveSquare( );
		end
		row = row+1
	end
]]--
	local row = 1

	function reviveBlock(  )
		for i=row,8-row do
			self:edgify()
			self.paint[row][i]:reviveSquare( );
			self.paint[i][row]:reviveSquare( );
			self.paint[8-row][8-i]:reviveSquare( );
			self.paint[8-i][8-row]:reviveSquare( );
		end
		row = row+1
	end
	
	local timer1 = timer.performWithDelay( 100, reviveBlock, 4 ) 

	function reset(  )
	--	_waveNumber = 1;
		_combo = 1;  
		_placed = true; 
		_gotLine = false;  
		_added = false;
		_gameOver = false;
	end

	local timer2 = timer.performWithDelay( 1000, reset, 1 ) 
end

function board:scanRow( row )
	local stack = stack.new()
	local lastWasWhite = false; 
	local color = 0;
	stack:push(1)
	for i=2, 7 do
		if (row[i] > 0) then
			if (#stack < 4) then
				lastWasWhite = false;
				if (row[i] == row[i - 1]) then
					stack:push(i)
					color = row[i]
				else
					stack:clear()
					stack:push(i)
				end
			else
				if (row[i] == color and not lastWasWhite) then
					stack:push(i)
				else
					color = 8
				end
			end
		else 
			lastWasWhite = true; 
		end
	end
	if (#stack < 4) then
		stack:clear()
	end
--	stack:print(  )
	return stack
end
return board







