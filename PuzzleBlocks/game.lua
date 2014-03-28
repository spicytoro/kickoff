----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local board = require("board")
local events = require("events")
local nextBlocks = require("nextBlocks")
local ScoreKeeper = require( "ScoreKeeper" )
local scene = storyboard.newScene()
local W = display.contentWidth
local H = display.contentHeight

local ScoreKeeper = ScoreKeeper.new("score")
----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	local board = board.new()
	local nextBlocks = nextBlocks.new()
	_nextBlocks = nextBlocks; 
	_board = board;
	for i=1,7 do
		_colors:add(math.random(1,5))
	end
	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	local scoreText = display.newText("0", W/2, 105, system.native, 90)
	scoreText:setFillColor( .5, .5, .5 )

	local playAgain = display.newRect( W - 50, 50, 50, 50 )
		playAgain:setFillColor( .5, .5, .5 )

	function touchPlayAgain( e )
		if (e.phase == "ended") then
			board:revive();
			board:nextWave()
		end
	end

	playAgain:addEventListener( "touch", touchPlayAgain )


	local highScoreText = display.newText( { 
		text = "Best: "..ScoreKeeper:getHighScore(), 
		x = W/2, 
		y = H - 80, 
		font = system.native, 
		fontSize = 30,
		align = "left"
		} )
	
	highScoreText:setFillColor( .5, .5, .5 )

	local function nextWave()
		if (_gameOver) then
			_gameOver = false; 
			board:remove()
		end


		if (_score > 100) then
			_waveNumber = math.min(math.floor(math.pow( _score, .25 ),5))
		else 
			_waveNumber = 3; 
		end

		
		if (not _gotLine) then
			if (_placed) then
				for i=1,_waveNumber do
					_colors:add(math.random(1,5))
				end
				board:nextWave(_waveNumber)
				board:print( )
				_placed = false; 
			end
		else
			_placed = false;  
		end
		if (tonumber(scoreText.text) ~= _score) then
			local number = tonumber(scoreText.text)
			number = number + 1
			scoreText.text = number
			number = nil
		end
	end
	Runtime:addEventListener( "enterFrame", nextWave )
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------

	Runtime:removeEventListener( "enterFrame", nextWave )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene