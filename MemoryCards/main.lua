-- Hide the iPhone status bar
display.setStatusBar( display.HiddenStatusBar )

-- Add a global background
--local bg = display.newRect( display.screenOriginX,
--                            display.screenOriginY, 
--                            display.pixelWidth, 
--                            display.pixelHeight)
                            
--bg.x = display.contentCenterX
--bg.y = display.contentCenterY
--bg:setFillColor( 100/255, 0/255, 0/255 )
local bg = display.newRect( display.screenOriginX,
                            display.screenOriginY, 
                            display.pixelWidth, 
                            display.pixelHeight)
                            
bg.x = display.contentCenterX
bg.y = display.contentCenterY
bg:setFillColor( 255/255, 255/255, 255/255 )

local background = display.newImageRect( "background.png", display.contentWidth, display.contentHeight )
background.anchorX = 0
background.anchorY = 0
background.x, background.y = 0, 0
--group:insert(background)

-- Initialize our global variables
local globals = require( "globals" )
globals.levelNum = 1
globals.score = 0
globals.ht=display.contentHeight
globals.wt=display.contentWidth

--Loads sounds. Done here so that we don't have to keep on creating and disposing of them!
local sounds = {}
sounds["select"] = audio.loadSound("sounds/select.mp3")
sounds["pop"] = audio.loadSound("sounds/pop.mp3")



function playSound(name) --Just pass a name to it. e.g. "select"
	audio.play(sounds[name])
end

-- Start up Storyboard
local storyboard = require( "storyboard" )
storyboard.gotoScene( "scene_splash" )

