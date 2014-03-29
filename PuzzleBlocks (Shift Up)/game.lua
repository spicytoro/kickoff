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
local W, H = display.contentWidth, display.contentHeight


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
	local frontGroup = display.newGroup( )
	local backGroup = display.newGroup( ); 
	_group = backGroup
	-- place underneath board
	local got = {
		text = "Game Over", 
		x = W/2, 
		y = H/2 - 100, 
		width = 752, 
		height = 324,
		font = system.native, 
		fontSize = 150,
		align = "center"
	}

	local gameOverText = display.newText(got)
	gameOverText:setFillColor( .5, .5, .5 )
	gameOverText.alpha = 0; 

	local highScoreText = display.newText( { 
		text = "", 
		x = W/2, 
		y = H - 135/2 - 13, 
		font = system.native, 
		fontSize = 30,
		align = "left"
		} )
	
	highScoreText:setFillColor( .5, .5, .5 )
	highScoreText.alpha = .4


	local board = board.new()

	local comboText = display.newText( { 
		text = "",
		x = W/2, 
		y = H - 135 - 19, 
		font = system.native, 
		fontSize = 100,
		align = "left"
		} )
	
	frontGroup:insert( comboText, backGro )
	comboText:setFillColor( .5, .5, .5 )
	comboText.alpha = .4; 

	local scoreText = display.newText("0", W/2, 135, system.native, 130)
	scoreText:setFillColor( .5, .5, .5 )
	scoreText.alpha = .4

	local playAgain = display.newRect( W - 50, 50, 100, 100 )
	--	playAgain:setFillColor( .3, 1, 1 )

	local group = self.view
	local nextBlocks = nextBlocks.new(H-4)
--	local nextBlocksTop = nextBlocks.new(H-4)
	_nextBlocks = nextBlocks;
--	_nextBlocksTop = nextBlocksTop 
	_board = board;
	for i=1,7 do
		_colors:add(math.random(1,5))
	end
	
	function playAgain:touch(e)
		if (e.phase == "began") then
			display.getCurrentStage( ):setFocus( self )
			self.hasFocus = true
			
		elseif (self.hasFocus) then
			if(e.phase == "ended" or e.phase == "canceled") then
			-----------
			-- Reset -- 
			-----------
				local function resetGame(  )
					local tranny = transition.to(gameOverText, {time = 1000, alpha = 0})
					_score = 0;
					_combo = 0; 
					scoreText.text = "0"
					board:revive();
					display.getCurrentStage( ):setFocus(nil)
					self.hasFocus = nil
				end

				-- if midgame reset
				if (board.paint[1][1].image.alpha == 0) then
					resetGame()
				else
					board:remove()
					local timer3 = timer.performWithDelay( 2000, resetGame, 1)
				end

				-- if gameover reset

			end
		end
	end
	

	playAgain:addEventListener( "touch", playAgain )
	local top = display.newGroup( );
	local function nextWave(e)
		
		comboText.text = "×".._combo

		if (_gameOver) then
			---------------
			-- GAME OVER -- 
			---------------
			local tranny = transition.to(gameOverText, {time = 1000, alpha = 1})
			_gameOver = false; 
			board:remove()
		end
		highScoreText.text = "Best: "..ScoreKeeper:getHighScore()

	--[[	if (_score > 100) then
			local hold = math.floor(math.pow( _score, .185 ))
			if (hold > 5) then
				hold = 5; 
			end
			_waveNumber = hold; 
		else 
			_waveNumber = 3; 
		end ]]

		
		if (not _gotLine) then
			if (_placed) then
				for i=1,_waveNumber do
					_colors:add(math.random(1,5))
				end
				board:nextWave(_waveNumber)
				_placed = false; 
			end
		else
			_placed = false;  
		end
		if (tonumber(scoreText.text) < _score) then
			local number = tonumber(scoreText.text)
			number = number + 10
			if (number >= _score) then
				ScoreKeeper:update(_score);
				number = _score; 
			end
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