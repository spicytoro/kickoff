---------------------------------------------------------------------------------
-- SCENE NAME
-- Scene notes go here
---------------------------------------------------------------------------------
local globals = require( "globals" )

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- Clear previous scene
storyboard.removeAll()

-- local forward references should go here --


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-- Called when the scene's view does not exist:
function scene:createScene( event )
  local group = self.view
  
  local score = globals.score
  local timer = globals.timer
  local result = score
  local time = timer
  local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5


  local Win = display.newText("WIN!", 0, 0, globals.font.bold, 72 )
  Win.x = display.contentCenterX
  Win.y = display.contentCenterY -150
  Win.strokeWidth=6
  Win:setFillColor(0, 137/255, 254/255)
  Win:setStrokeColor(255/255, 255/255, 255/255)

  local resultsBoard=display.newRect(screenW/2, screenH/2, screenW/1.25, screenH/2.7)
  resultsBoard.strokeWidth = 9
  resultsBoard:setFillColor(1, 169/255, 171/255)
  resultsBoard:setStrokeColor(255, 255/255, 255/255)
  resultsBoard.alpha=.7




  local resultsText = display.newText( result, 0, 0, globals.font.bold, 64 )
  resultsText.x = display.contentCenterX-150
  resultsText.y = display.contentCenterY - 60
  resultsText:setFillColor(0, 137/255, 254/255)

  local points = display.newText("Points", 0, 0, globals.font.bold, 32 )
  points.x = display.contentCenterX-150
  points.y = display.contentCenterY -100
  points:setFillColor(0, 137/255, 254/255)


  local timeText = display.newText( time, 0, 0, globals.font.bold, 64 )
  timeText.x = display.contentCenterX+150
  timeText.y = display.contentCenterY-60
  timeText:setFillColor(0, 137/255, 254/255)


  local time = display.newText("Time", 0, 0, globals.font.bold, 32 )
  time.x = display.contentCenterX+150
  time.y = display.contentCenterY -100
  time:setFillColor(0, 137/255, 254/255)



  group:insert(resultsBoard)
  group:insert(resultsText)
  group:insert(timeText)
  group:insert(Win)
  group:insert(points)
  group:insert(time)
  local mainMenuButton = display.newText( "Main Menu", 0, 0, globals.font.bold, 64 )
  mainMenuButton.x = display.contentCenterX
  mainMenuButton.y = display.contentCenterY+50
  mainMenuButton:setFillColor(0, 137/255, 254/255)
  local function onTap( event )
    storyboard.gotoScene( "scene_splash", "fade", 300 )
  end
  mainMenuButton:addEventListener( "tap", onTap )
  group:insert( mainMenuButton )
  

  
 -- if ( levelNum <= 3 ) then
  local nextLevelButton = display.newText( "Play Again", 0, 0, globals.font.bold, 64 )
  nextLevelButton.x = display.contentCenterX
  nextLevelButton.y = display.contentCenterY + 124
  nextLevelButton:setFillColor(0, 137/255, 254/255)



    local function onTap( event )
      storyboard.gotoScene( "scene_game", "fade", 300 )
    end
    nextLevelButton:addEventListener( "tap", onTap )
    group:insert( nextLevelButton )

end


-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
  local group = self.view

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
  local group = self.view

end


-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
  local group = self.view

end


-- Called prior to the removal of scene's "view" (display view)
function scene:destroyScene( event )
  local group = self.view

end


-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
  local group = self.view
  local overlay_name = event.sceneName  -- name of the overlay scene
  
end


-- Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
function scene:overlayEnded( event )
  local group = self.view
  local overlay_name = event.sceneName  -- name of the overlay scene

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "willEnterScene" event is dispatched before scene transition begins
scene:addEventListener( "willEnterScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "didExitScene" event is dispatched after scene has finished transitioning out
scene:addEventListener( "didExitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-- "overlayBegan" event is dispatched when an overlay scene is shown
scene:addEventListener( "overlayBegan", scene )

-- "overlayEnded" event is dispatched when an overlay scene is hidden/removed
scene:addEventListener( "overlayEnded", scene )

---------------------------------------------------------------------------------

return scene
