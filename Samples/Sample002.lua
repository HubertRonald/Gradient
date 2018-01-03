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
local path="Sources/Images/Splash/"


local s=.4
local brush=Texture.new(path.."splashWhite_001.png",true)
w,h = brush:getWidth()*s, brush:getHeight()*s
local g = uiGradient.new()
local conf={
			color = {0x833ab4,0xfd1d1d,0xfcb045},
			anchor = {0, 0},				
			dimension = {w,h*.5},
			way = "lr",	
			position = {0,0},
			texture = {path.."splashWhite_001.png",true},
			anchorTexture={.5,.5},
			scaleTexture = {s,s},	-- sX,sY calculate for you scale perfect when deform is false
			deform = false,
			}
g:rectangle(conf)
stage:addChild(g)

-------------------
local radius=200
-------------------
local s=1
brush = Texture.new(path.."splashWhite_003.png",true)
w,h = brush:getWidth()*s, brush:getHeight()*s
local _g = uiGradient.new()
local conf={
			color = {0x833ab4,0xfd1d1d,0xfcb045},
			radius=radius,
			anchor = {0, 0},				
			dimension = {w,h},
			way = "oc",	
			position = {radius,radius*2},
			texture = {path.."splashWhite_003.png",true},
			anchorTexture={.5,.5},
			deform = false
			}
_g:circle(conf)
stage:addChild(_g)

local s=1
brush = Texture.new(path.."splashWhite_009.png",true)
w,h = brush:getWidth()*s, brush:getHeight()*s
local _1g = uiGradient.new()
local conf={
			color = {0x833ab4,0xfd1d1d,0xfcb045},
			radius=radius,
			anchor = {0, 0},				
			way = "co",	
			position = {_WD/2,radius*2.2},
			texture = {path.."splashWhite_009.png",true},
			anchorTexture={.5,.5},
			deform = false
			}
_1g:circle(conf)
stage:addChild(_1g)

local s=1
brush = Texture.new(path.."splashWhite_007.png",true)
w,h = brush:getWidth()*s, brush:getHeight()*s
local _2g = uiGradient.new()
local conf={
			color = {0x833ab4,0xfd1d1d,0xfcb045},
			radius=radius*.8,
			anchor = {0, 0},
			way = "co",	
			position = {_WD/2,radius*.8},
			texture = {path.."splashWhite_007.png",true},
			anchorTexture={.5,.5},
			deform = false
			}
_2g:circle(conf)
stage:addChild(_2g)

local s=3
brush = Texture.new(path.."splashWhite_005.png",true)
w,h = brush:getWidth()*s, brush:getHeight()*s
local _3g = uiGradient.new()
local conf={
			color = {0x833ab4,0xfd1d1d,0xfcb045},
			radius=radius*.8,
			anchor = {0, 0},
			way = "oc",	
			position = {_WD/2+radius*1.6,radius*.8},
			texture = {path.."splashWhite_005.png",true},
			anchorTexture={.5,.5},
			deform = false
			}
_3g:circle(conf)
stage:addChild(_3g)


local s=3
brush = Texture.new(path.."splashWhite_006.png",true)
w,h = brush:getWidth()*s, brush:getHeight()*s
local _4g = uiGradient.new()
local conf={
			color = {0x833ab4,0xfd1d1d,0xfcb045},
			radius=radius*.8,
			anchor = {0, 0},
			way = "co",	
			position = {_WD/2+radius*1.6,radius*2.2},
			texture = {path.."splashWhite_008.png",true},
			anchorTexture={.5,.5},
			deform = false
			}
_4g:circle(conf)
stage:addChild(_4g)