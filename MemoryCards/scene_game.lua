---------------------------------------------------------------------------------
-- SCENE NAME
-- Scene notes go here
---------------------------------------------------------------------------------
local globals = require( "globals" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local pauseGroup =display.newGroup()



-- Clear previous scene
storyboard.removeAll()


-- local forward references should go here --
local score
local scoreText
local levelNum=globals.levelNum
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local totalButtons = 0 --Track total on screen buttons
local secondSelect = 0 --Track if first or second button select
local checkForMatch = false --Let the app know when to check for matches
local buttonsLeft=0
local button = {}
local buttonCover = {}
local buttonImages = {{1,1, 2,2, 3,3, 4,4, 5,5, 6,6},  {1,1, 2,2, 3,3, 4,4, 5,5, 6,6, 7,7, 8,8, 9,9, 10,10}, {1,1, 2,2, 3,3, 4,4, 5,5, 6,6, 7,7, 8,8, 9,9, 10,10, 11,11, 12,12, 13,13, 14,14, 15,15}}

local lastButton=display.newText("", 0,0,system.native, 60)
local cardsLeft
local number
local txt_timer
local pause=false
local cardsFlipped = false
local scale=globals.size[levelNum]

local cardH=scale*152
local cardW=scale*120
local cardsW=levelNum+2
local cardsH=levelNum+3
local spacingH=((screenH-(cardsH*cardH))/(cardsH+2))
local spacingW=((screenW-(cardsW*cardW))/(cardsW+2))

--
local matchText
local pauseText
local pauseBoard
local pauseT
local resumeButton
local menuButton


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

function scene.updateScore(change)
  score = score + change
  scoreText.text = score

  if (change>0)then
    cardsLeft=cardsLeft-2
    print(cardsLeft)
  end

  if ( cardsLeft ==0 ) then
    -- level over
    globals.score = score
    globals.timer = number
    storyboard.gotoScene( "scene_results" )
  end
end


function scene.pause()
  if cardsFlipped then
    scene.view:insert(pauseGroup)
    pauseGroup.isVisible=true
    pause=true
    cardsFlipped=false  
  end
end


function scene.resume()
  pause=false
  pauseGroup.isVisible=false
  timer.performWithDelay(300, function()
    cardsFlipped=true
  end)
end


function scene.menu()
  scene.view:insert(pauseGroup)
  storyboard.gotoScene( "scene_splash" )

end


function scene.restart()
  buttonImages = {{1,1, 2,2, 3,3, 4,4, 5,5, 6,6},  {1,1, 2,2, 3,3, 4,4, 5,5, 6,6, 7,7, 8,8, 9,9, 10,10}, {1,1, 2,2, 3,3, 4,4, 5,5, 6,6, 7,7, 8,8, 9,9, 10,10, 11,11, 12,12, 13,13, 14,14, 15,15}}
  local pauseGroup=display.newGroup()
  storyboard.gotoScene( "scene_reset", "fade", 250 )

end



function scene.game(object, event)
  if(event.phase == "began" and cardsFlipped) then   
    if(checkForMatch == false and secondSelect == 0) then
      playSound("pop")
      --Flip over first button
      transition.to (buttonCover[object.number], {time=150, alpha=0})    
      buttonCover[object.number].alpha = 0;
      lastButton = object
      checkForMatch = true      
      timer.performWithDelay(200, function()    
        buttonCover[object.number].isVisible = false;
        end, 1)

    elseif(checkForMatch == true) then
      if(secondSelect == 0 and lastButton.number~=object.number) then
        --Flip over second button
        playSound("pop")
        transition.to (buttonCover[object.number], {time=150, alpha=0})    
        buttonCover[object.number].alpha = 0;
        secondSelect = 1;
        --cardsFlipped=false
        timer.performWithDelay(150, function()    
          buttonCover[object.number].isVisible = false;
        end, 1)


        --If buttons do not match, flip buttons over
        if(lastButton.myName ~= object.myName) then
          matchText.alpha =0
          matchText.text = "-50";
          matchText:setFillColor(1, 0, 0)
          matchText.y=object.y+80
          matchText.x=object.x+40
          transition.to (matchText, {time=100, alpha=1})    
          transition.to (matchText, {time=500, xScale=1.3, yScale=1.3})  
          timer.performWithDelay(600, function()
            scene.updateScore(-50)
            scoreText.text=score
            matchText.text = " ";
            matchText.xScale=1
            matchText.yScale=1
            checkForMatch = false;
            secondSelect = 0;
            transition.to (buttonCover[lastButton.number], {time=300, alpha=1})    
            transition.to (buttonCover[object.number], {time=300, alpha=1})    
            buttonCover[lastButton.number].isVisible = true;
            buttonCover[object.number].isVisible = true;
            --buttonCover[lastButton.number].isVisible = true;
            --buttonCover[object.number].alpha = 1;
          end, 1)         
          


        --If buttons DO match, remove buttons
        elseif(lastButton.myName == object.myName  and lastButton.number~=object.number) then
          matchText.alpha =0
          matchText.text = "+150";
          matchText.y=object.y+80
          matchText.x=object.x+40
          matchText:setFillColor(0, 137/255, 254/255)
          transition.to (matchText, {time=100, alpha=1})  
          transition.to (matchText, {time=500, xScale=1.3, yScale=1.3}) 
          timer.performWithDelay(600, function()    
            buttonsLeft=buttonsLeft-2
            print(buttonsLeft)
            scoreText.text=score        
            matchText.text = " ";
            matchText.xScale=1
            matchText.yScale=1
            checkForMatch = false;
            secondSelect = 0;
            buttonCover[lastButton.number]:removeSelf();
            buttonCover[object.number]:removeSelf();
            lastButton:removeSelf();
            object:removeSelf();
            scene.updateScore(150)
          end, 1) 
        end       
      end     
    end
  end

end


function scene.cards(level)


  local x = -cardW/2.6

  for count = 1,(cardsW) do
    x = x + cardW +spacingW
    y = -cardH/2.6+10
    for insideCount = 1,(cardsH) do
      y = y + cardH+spacingH
      --Assign each image a random location on grid
      temp = math.random(1,#buttonImages[level])
     button[count] = display.newImage(buttonImages[level][temp] .. ".png");
     --button[count] = display.newText(buttonImages[level][temp], 0,0,system.native, 60)
     --button[count]:setFillColor(0, 0, 0)

      --Position the button
      button[count].x = x;
      button[count].y = y;    
      --Give each a button a name
      button[count].myName = buttonImages[level][temp]
      button[count].number = totalButtons
      button[count]:scale(scale, scale)
      --Remove button from buttonImages table
      table.remove(buttonImages[level], temp)
      totalButtons = totalButtons + 1
    

      button[count].touch = scene.game    
      button[count]:addEventListener( "touch", button[count] )
      scene.view:insert(button[count]) 
    end
  end
end

function scene.cardsCover(level)
  timer.performWithDelay(1000, function()
  x = -cardW/2.6
  totalButtons=0

  for count = 1,(cardsW) do
    x = x + cardW +spacingW
    y = -cardH/2.6+10

  
    for insideCount = 1,(cardsH) do
      y = y + cardH+spacingH
       
          
      --Set a cover to hide the button image
        buttonCover[totalButtons] = display.newImage("back.png");
        buttonCover[totalButtons].alpha=0
        transition.to (buttonCover[totalButtons], {time=500, alpha=1})    
        buttonCover[totalButtons].x = x; buttonCover[totalButtons].y = y;
        buttonCover[totalButtons]:scale(scale, scale)
        print(buttonCover[totalButtons])
        scene.view:insert(buttonCover[totalButtons])

        totalButtons = totalButtons + 1
      
        
      end
    end


    go = display.newText("GO!", 0, 0, globals.font.bold, 72)
    go.x = screenW/2
    go.y= screenH/2
    go:setFillColor(0, 137/255, 254/255)
    timer.performWithDelay(450, function()
    scene.view:insert(go)
    go:removeSelf();
    cardsFlipped=true
    end, 1)
  end, 1)

end



-- Called when the scene's view does not exist:
function scene:createScene( event )


  buttonImages = {{1,1, 2,2, 3,3, 4,4, 5,5, 6,6},  {1,1, 2,2, 3,3, 4,4, 5,5, 6,6, 7,7, 8,8, 9,9, 10,10}, {1,1, 2,2, 3,3, 4,4, 5,5, 6,6, 7,7, 8,8, 9,9, 10,10, 11,11, 12,12, 13,13, 14,14, 15,15}}
  score=0
  number=-1
  local group = self.view
  cardsLeft=(levelNum+2)*(levelNum+3)

  local topBar=display.newRect(screenW/2, 30, screenW, screenH/18)
  topBar.strokeWidth = 9
  topBar:setFillColor(1, 169/255, 171/255)
  topBar:setStrokeColor(123/255, 53/255, 51/255)
  

  scoreText = display.newText(0, 0, 0, globals.font.bold, 48 )
  scoreText.x = display.contentCenterX
  scoreText.y = 32
  scoreText:setFillColor(0, 137/255, 254/255)

  matchText = display.newText("", 0, 0, globals.font.bold, 32)
  matchText.x = screenW/2
  matchText.y= 100
  matchText:setFillColor(0, 137/255, 254/255)

  pauseText = display.newImage("pause.png")
  pauseText.x = screenW-50
  pauseText.y= 25

  pauseText.touch = scene.pause 
  pauseText:addEventListener( "touch", pauseText)

  txt_timer = display.newText(0, 0, 0, globals.font.bold, 48)
  txt_timer.x = 50
  txt_timer.y = 30
  txt_timer:setFillColor(0, 137/255, 254/255)
  function fn_counter()
    if(pause==false) then
    number = number + 1
    txt_timer.text = number
    end
  end

  timer.performWithDelay(1000, fn_counter, 0)
  group:insert(topBar)
  group:insert(pauseText)
  group:insert( scoreText )
  group:insert(txt_timer)
  self.cards(levelNum)
  group:insert( matchText )
  pauseGroup.isVisible=false

  pauseT=display.newText("PAUSE!", 0,0, globals.font.bold, 96)
  pauseT.x = screenW/2
  pauseT.y= screenH/2-100
  pauseT:setFillColor(0, 137/255, 254/255)

  pauseBoard=display.newRect(screenW/2, screenH/2, screenW/1.25, screenH/2.7)
  pauseBoard.strokeWidth = 9
  pauseBoard:setFillColor(1, 169/255, 171/255)
  pauseBoard:setStrokeColor(255, 255/255, 255/255)
  pauseBoard.alpha=.7

  resumeButton = display.newImage("resumeButton.png");
  resumeButton.x = screenW/2
  resumeButton.y= screenH/2+65
  resumeButton.touch = scene.resume 
  resumeButton:addEventListener( "touch", resumeButton)

 -- restartButton = display.newImage("restartButton.png");
 -- restartButton.x = screenW/2
 -- restartButton.y= screenH/2
 -- restartButton.touch = scene.restart 
 -- restartButton:addEventListener( "touch", restartButton)


  menuButton = display.newImage("menuButton.png");
  menuButton.x = screenW/2
  menuButton.y= screenH/2+130
  menuButton.touch = scene.menu 
  menuButton:addEventListener( "touch", menuButton)



  pauseGroup:insert(pauseBoard)
  pauseGroup:insert(pauseT)
  pauseGroup:insert(resumeButton)
  pauseGroup:insert(menuButton)
  --pauseGroup:insert(restartButton)

  




end


-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
  local group = self.view

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
local group = self.view
local levelNum = globals.levelNum
self.cardsCover(levelNum)
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
