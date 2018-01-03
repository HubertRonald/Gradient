----------------------------------------
--	FIX DIMENSION DEVICE
----------------------------------------
-- Scale Mode: No Scale Top Left
-- logical dimension: 320 x 480
-- Orientation: LandScape
----------------------------------------
print("\n")
application:setOrientation(Application.LANDSCAPE_LEFT) 
application:setBackgroundColor(0x3a3a3a)


----------------------------------------
--all change if you use landscape
----------------------------------------
_W = application:getContentWidth()
_H  = application:getContentHeight()

application:setLogicalDimensions(_W, _H)
_W = application:getLogicalWidth()
_H  = application:getLogicalHeight()	

Wdx = application:getLogicalTranslateX() / application:getLogicalScaleX()
Hdy = application:getLogicalTranslateY() / application:getLogicalScaleY()
_WD,_HD  = application:getDeviceWidth(), application:getDeviceHeight()	
_Diag, _DiagD = _W/_H, _WD/_HD
_HD,_WD = _WD,_HD
----------------------------------------
local uiGradient = require "uiGradient"
local path="Sources/Images/Faces/"

local ed=4	--edges four
local radius = 250
local g3 = uiGradient.new()
local conf = {
				edges=ed*2,	--optional minimum is 56 by default
				radius=radius,
				color={0x833ab4,0xfd1d1d,0xfcb045},
				alpha={.5, .7, .3},
				way = "oc",
				position={_WD/2-250,_HD/2},
				scalePolygon = {1,1},
				
				texture = {path.."peruvianModel_Maju_001.png",true},
				anchorTexture={.54,.5},
				scaleTexture = {1,1},
				hole=false,
				jaggedFree=true,
				colorOn=true,
				deform=false
				}
g3:circle(conf)	--	circle function call regular polygon function so this works with 54 edges by default 
				--	but you can up it if you need a rendering best
stage:addChild(g3)

local g3 = uiGradient.new()
local conf = {
				edges=ed,	--optional minimum is 56 by default
				radius=radius,
				color={0x833ab4,0xfd1d1d,0xfcb045},
				alpha={.5, .7, .3},
				way = "oc",
				position={_WD/2+250,_HD/2},
				rotationMesh = 180/ed,
				
				texture = {path.."peruvianModel_Maju_001.png",true},
				anchorTexture={.54,.5},
				scaleTexture = {1,1},
				hole=true,
				jaggedFree=true,
				colorOn=true,
				deform=false
				}
g3:circle(conf)	--	circle function call regular polygon function so this works with 54 edges by default 
				--	but you can up it if you need a rendering best
stage:addChild(g3)