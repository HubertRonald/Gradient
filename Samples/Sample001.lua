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

pcall(function() require "json" end)
local uiGradient = require "uiGradient"


local function load( filename )
	local path = filename..".json"
	local contents			-- will hold contents of file
	local file = io.open( path, "r" ) -- io.open opens a file at path. returns nil if no file found
 
	if file then
		contents = file:read( "*a" ) -- read all contents of file into a string
		io.close( file )		-- close the file after using it
		return json.decode( contents ) -- return Decoded Json string
	else
		return nil	-- or return nil if file didn't ex
	end
 
end
 
--uiGradients sources
local loader = UrlLoader.new("https://raw.githubusercontent.com/ghosh/uiGradients/master/gradients.json")
local function onComplete(e)
	
	local out = io.open("|D|data.json", "wb")
	out:write(e.data)
	out:close()
	
	loadGraph()
end

local function onError() print("error") end
local function onProgress(e) print("progress: " .. e.bytesLoaded .. " of " .. e.bytesTotal) end

loader:addEventListener(Event.COMPLETE, onComplete)
loader:addEventListener(Event.ERROR, onError)
loader:addEventListener(Event.PROGRESS, onProgress)


function loadGraph()
	
	local datos = load("|D|data")

	--	update syntax colors
	for i=1, #datos do
		for j=1, #datos[i].colors do 
			datos[i].colors[j] = string.gsub(datos[i].colors[j],"#","0x")
		end
	end


	--random color select
	local n=math.random(1,#datos)
	
	----------------------------------------------------------------------
	--sample
	----------------------------------------------------------------------
	local path="Sources/Images/Landscape/"
	local g = uiGradient.new()
	local conf={
			color = datos[n].colors,		-- colors are like vertex: minimum 2 colors 
			
			----------------------------------------------------------------------
			-- by this sample quantity color are random so quantity alphas require some algorithm 
			-- so you can try different alphas but if you know the amount of colors
			-- you can configure the alphas manually
			----------------------------------------------------------------------
			alpha = {},					-- if {} you want equal quantity alpha: 1 by default
										-- quantity alphas by each color
			----------------------------------------------------------------------

			anchor = {0, 0},				
			dimension = {_WD,_HD},
			position = {0,0},
			rotation = 0,
			way = "tb",					-- from top to bottom also: "bt", "lr" and "rl" --Orientation: Portrait
			
			----------------------------------------------------------------------
			-- enable texture = {... so you can see how this works
			----------------------------------------------------------------------
			texture = {path.."pexels-photo-89432.png",true},	-- if {} you don't want this option
															-- or ike always	{"image.png", false, {transparentColor = 0xff00ff}}
															--					{"image.png", true, {wrap = Texture.REPEAT}}
															-- Pixel Data		{nil,300,400;, false, {extend=false}}
			anchorTexture={.2,.5},
			scaleTexture = {0,0},		-- sX,sY calculate for you scale perfect when deform is false
										-- and take larger axis scale viz {.6,0} equal to {.6,.6} when deform is false
			deform = false,				-- if you don't need animation like to jelly
			colorOn = true,
			
			----------------------------------------------------------------------
			-- These paramentes are in Version Aplha in this moment
			----------------------------------------------------------------------
			--alphaGrandient = true,	-- if it's true so alpha'll fall porportionally
			--perX = {}, 				-- quantity by each color "not alpha":
										-- if {} you want equal quantity colors - 1
										-- cumulative percentaje (max number One) or .
										-- Sample: 0.2, 0.4, 0.6, 0.9, 1 never start ZERO!!!
			--perY = {},					-- quantity by each color "not alpha":
										-- if {} you want equal quantity colors - 1
										-- cumulative percentaje (max number One) or .
										-- Sample: 0.2, 0.4, 0.6, 0.9, 1 never start ZERO!!!
			----------------------------------------------------------------------
			
		}

	g:rectangle(conf)

	--helper color info
	local function listColors(d)
		t={}; for j=1, #d do t[#t+1] = d[j]..tostring(j==#d and "" or " --> ") end
		return table.concat(t)
	end
	local path="Sources/Fonts/"
	--name info
	local font=TTFont.new(path.."Roboto-Regular.ttf",20)
	local textName = TextField.new(font,datos[n].name)
	textName:setTextColor(0xfcfcfc)
	textName:setPosition(_WD / 2 - textName:getWidth()/1.5, 50)
	textName:setAlpha(.9)
	
	--color info
	local colorsName = TextField.new(TTFont.new(path.."Roboto-Regular.ttf",14),listColors(datos[n].colors))
	colorsName:setTextColor(0xfcfcfc)
	colorsName:setPosition(_WD / 2 - colorsName:getWidth()/1.5, 90)
	colorsName:setAlpha(.9)
	
	--rotate gradient
	local p,c = {"tb","bt", "lr", "rl"}, 1
	local Rotate = TextField.new(font,"Rotate Gradient")
	Rotate:setTextColor(0xfcfcfc)
	Rotate:setPosition(_WD / 2 - Rotate:getWidth()/1.5, _HD-50)
	Rotate:setAlpha(.9)
	Rotate:addEventListener(Event.MOUSE_DOWN, 
		function(e)
			if Rotate:hitTestPoint(e.x, e.y) then
				g:clean()
				c=c+1
				conf.way=p[math.max(math.floor(c%4),1)]
				g:rectangle(conf)
				e:stopPropagation()
			end
		end)

	--change colors
	stage:addEventListener(Event.MOUSE_DOWN, 
		function(e)
			g:clean()
			n=math.random(1,#datos)
			
			textName:setText(datos[n].name)
			colorsName:setText(listColors(datos[n].colors))
			
			conf.way=p[math.max(math.floor(c%4),1)]
			conf.color = datos[n].colors
			g:rectangle(conf)
			
			print("\n",datos[n].name,": ", listColors(datos[n].colors))
			e:stopPropagation()
		end)
	
	stage:addChild(g)

	stage:addChild(textName)
	stage:addChild(colorsName)
	stage:addChild(Rotate)
	print(n,datos[n].name,": ", listColors(datos[n].colors))

end
