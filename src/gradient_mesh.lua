
--[[
	---------------------------------------------
	ui Gradient
	a script mesh by hubert ronald
	---------------------------------------------
	a script for draw many shapes with gradient, antialiasing
	Gideros SDK Power and Lua coding.
	Inspiration: uiGradients
			https://uigradients.com
			https://raw.githubusercontent.com/ghosh/uiGradients/master/gradients.json
	
	Design & Coded
	by Hubert Ronald
	contact: hubert.ronald@gmail.com
	Development Studio: [-] Liasoft
	Date: Jan 2th, 2018
	
	THIS PROGRAM is developed by Hubert Ronald
	https://sites.google.com/view/liasoft/home
	Feel free to distribute and modify code,
	but keep reference to its creator
	The MIT License (MIT)
	
	Copyright (C) 2018 Hubert Ronald
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	
	---------------------------------------------
	version 1.0.0			|		dic.06.2017			| Launch on Gideros Forum
	version 1.0.1			|		dic.11.2017			| Texture Support (Scale, Anchor Point, Deform)
	version 1.1.0			|		jan.02.2018			| Radial Gradient, regular polygons, antialiasing mode**,
											  Shapes derivatives of regular polygons like circles,
											  donuts, ellipses, rectangles and so on.
											  Regular polygons with hole
											  Rotate only mesh
											  **/ This feature is only available for mesh without texture
	---------------------------------------------
	CLASS: uiGradient
	---------------------------------------------
	Functions:
	-------------------------------
	function uiGradient:setup(conf)
	-------------------------------
	In this function is detail each
	variable used
	–––––––––––––––––––––––––––––––––––––––––––––
	
--]]
-------------------------
--helper math function
-------------------------
local sin = math.sin
local cos = math.cos
local tan = math.tan
local pi = math.pi
local rad = math.rad
local deg = math.deg
local floor = math.floor
local max = math.max
local min = math.min

-------------------------
--helper function
-------------------------
local function reverse(tbl)
	for i=1, floor(#tbl / 2) do
		tbl[i], tbl[#tbl - i + 1] = tbl[#tbl - i + 1], tbl[i]
	end
	return tbl
end


-------------------------
-- Class
-------------------------
local uiGradient = Core.class(Mesh)

function uiGradient:init()
	self.mesh = Mesh.new()
	self.conf = {}
	self.conf.texture = {}		--	default without texture
	self:addChild(self.mesh)	--	it avoids conflict and you able be to reuse code
	self:clean()
end


----------------------------------------------------------------------
-- Important read this information about parametres
----------------------------------------------------------------------
function uiGradient:setup(conf)
	self.conf={
		----------------------------------------------------------------------
		-- this notation --(!!!) means be careful!!!
		----------------------------------------------------------------------
		-- regular polygon info
		----------------------------------------------------------------------
		edges = 3,
		radius = 100, 
		center = {0,0},
		scalePolygon = {1,1},		--(!!!) values higher than 1, could deforming your texture
		hole = false,			--(!!!) it's only true when you call regular polygon function and derivative functions
		rIn = 0,			--(!!!) if hole == true so you can defiened radius inside (rIn) < radius
		
		----------------------------------------------------------------------
		-- color info
		----------------------------------------------------------------------
		color = {"0xfcfcfc","0xfcfcfc"},	-- colors are like edge: minimum 2 colors
		alpha = {},				--(!!!) if {} you want equal quantity alpha: 1 by default
							--quantity alphas by each color, for example {.5, .8} by two colors
		
		----------------------------------------------------------------------
		-- These paramentes are in Version Aplha in this moment
		----------------------------------------------------------------------
		--alphaGrandient = false,		-- if it's true so alpha'll fall porportionally
		perX = {}, 				--(!!!) quantity by each color "not alpha":
							-- if {} you want equal quantity colors - 1
							-- cumulative percentaje (max number One) or .
							-- Sample: 0.2, 0.4, 0.6, 0.9, 1 never start ZERO!!!
									
		perY = {},				--(!!!) quantity by each color "not alpha":
							-- if {} you want equal quantity colors - 1
							-- cumulative percentaje (max number One) or .
							-- Sample: 0.2, 0.4, 0.6, 0.9, 1 never start ZERO!!!
		radialGradient = false,			--(!!!) it's only true when you call regular polygon function and derivative functions
		
		----------------------------------------------------------------------
		-- geometry info
		----------------------------------------------------------------------
		anchor = {.5, .5},				
		dimension = {128,128},
		dimHole = {0,0},			--(!!!) it only works when you call regular polygon function and derivative functions
		position = {320/2,480/2},
		rotation = 0,				-- as mesh as texture are going to rotate
		rotationMesh = 0,			-- only mesh is going to rotate
		
		way = "tb",				-- Horizontal or Vertical Gradient from top to bottom also: "bt", "lr" and "rl" -- Orientation: Portrait
							--(!!!) Radial gradient from: "co" to "oc": in this moment it doesn't work
		
		jaggedFree = true,			-- antialiasing mode
		fromFunction = "rectangle",	
		
		----------------------------------------------------------------------
		-- texture info
		----------------------------------------------------------------------
		texture = {},				-- if {} you don't want this option
							-- or ike always	{"image.png", false, {transparentColor = 0xff00ff}}
							--			{"image.png", true, {wrap = Texture.REPEAT}}
							-- Pixel Data		{nil,300,400;, false, {extend=false}}
		anchorTexture = {.5,.5},		
		scaleTexture = {1,1},			-- sX,sY calculate for you scale perfect when deform is false
							-- and take larger axis scale viz {.6,0} equal to {.6,.6} when deform is false
		textureArrayCoordinates={},		-- empty
		deform = false,				-- if you don't need animation like to jelly
		colorOn = true,				-- if false texture will take shape of the mesh 
		
	}
	
	-- update config parameters
	if conf then for k,v in pairs(conf) do self.conf[k] = v end end

	-- minimum two colors those can be the same
	if #self.conf.color<2 then self.conf.color[#self.conf.color+1] = self.conf.color[1] end
	
	-- min edge by polygon regular: 3
	self.conf.edges = max(3,self.conf.edges)
	
	-- colors and alphas
	if next(self.conf.alpha)==nil then
		for k,_ in pairs(self.conf.color) do
			if self.conf.alphaGrandient then
				self.conf.alpha[#self.conf.alpha+1] = (#self.conf.color-k+1)/#self.conf.color
			else
				self.conf.alpha[#self.conf.alpha+1]=1
			end
		end
	end
	
	
	-- colors quantity
	if not self.conf.radialGradient or not self.conf.hole then
		if next(self.conf.perX)==nil then for k=1, #self.conf.color-1 do self.conf.perX[#self.conf.perX+1]=k/(#self.conf.color-1) end end
		if next(self.conf.perY)==nil then for k=1, #self.conf.color-1 do self.conf.perY[#self.conf.perY+1]=k/(#self.conf.color-1) end end
	
	else
		if self.conf.hole then
			if next(self.conf.perX)==nil and next(self.conf.perY)==nil then
				local r, n = self.conf.radius, #self.conf.color
				local rIn = self.conf.rIn==0 and r/n or self.conf.rIn
				local cte = (r-rIn)/(#self.conf.color*r)
				
				for i=1, n do
					c = i*cte+rIn/r
					self.conf.perX[#self.conf.perX+1] = c
					self.conf.perY[#self.conf.perY+1] = c
				end
			end
		end
	end
	
	
	
	
end

-- draw mesh canvas
function uiGradient:draw(conf)
	
	-- vertex, index, color
	self.mesh:setVertexArray(unpack(self.vertexArray))
	self.mesh:setIndexArray(unpack(self.indexArray))
	if conf.colorOn then self.mesh:setColorArray(unpack(self.colorArray)) end
	
	-- texture
	if #self.conf.texture>0 then
		local d = conf.dimension
		local img = Texture.new(unpack(self.conf.texture))
		local tw,th = img:getWidth(),img:getHeight()
		
		local xSize, ySize	= #conf.color, #conf.color
		local px, py	 	= conf.perX, conf.perY
		local dimX, dimY 	= d[1], d[2]
		if conf.fromFunction == "regularPolygon" then dimX, dimY = dimX*2, dimY*2 end
		-----------------------
		-- fix scale texture
		-----------------------
		if conf.deform then
			conf.scaleTexture[1] = max(conf.scaleTexture[1],dimX/tw)
			conf.scaleTexture[2] = max(conf.scaleTexture[2],dimY/th)
		else
			conf.scaleTexture[1] = max(conf.scaleTexture[1], dimX/tw, conf.scaleTexture[2], dimY/th)
			conf.scaleTexture[2] = conf.scaleTexture[1]
		end
		--print(unpack(conf.scaleTexture))
		local dimX, dimY 	= dimX/conf.scaleTexture[1], dimY/conf.scaleTexture[2]
		local dx, dy	 	= tw-dimX, th-dimY
		local aX, aY	 	= conf.anchorTexture[1], conf.anchorTexture[2]
		
		if next(self.conf.textureArrayCoordinates)== nil then
			if conf.fromFunction == "rectangle" then
				for j=1, ySize do		
					for i=1, xSize do	
						----------------------------------------------
						-- vertex
						----------------------------------------------
						self.conf.textureArrayCoordinates[#self.conf.textureArrayCoordinates+1] = dimX*px[i]+aX*dx	--vertex X
						self.conf.textureArrayCoordinates[#self.conf.textureArrayCoordinates+1] = dimY*py[j]+aY*dy	--vertex Y
					end
				end
			elseif conf.fromFunction == "regularPolygon" then
				---------------------------------------------------
				-- vertex out
				---------------------------------------------------
				conf.scaleTexture[1] = max(conf.scaleTexture[1], dimX/tw, conf.scaleTexture[2], dimY/th)

				conf.scaleTexture[2] = conf.scaleTexture[1]
				if conf.scaleTexture[1]>1 then conf.scaleTexture={1/conf.scaleTexture[1],1/conf.scaleTexture[2]} end
				local sX, sY = unpack(self.conf.scalePolygon)
				local stX,stY = unpack(conf.scaleTexture)
				local edges, a = self.conf.edges, 0
				
				local r=min(tw/conf.scaleTexture[1], th/conf.scaleTexture[2]*sY,tw*conf.scaleTexture[1], th*conf.scaleTexture[2])/2
				local dimX, dimY 	= r*sX,r*sY
				local cX, cY = tw*aX, th*aY
				
				local deltaX, deltaY = 0,0
				local indexStartColor = 1	
				if not conf.hole then
					indexStartColor = 0
					-- center
					self.conf.textureArrayCoordinates[#self.conf.textureArrayCoordinates+1] = cX+deltaX	--x
					self.conf.textureArrayCoordinates[#self.conf.textureArrayCoordinates+1] = cY+deltaY	--y
				end
				
				for j=1-indexStartColor, #px - indexStartColor do
					for i=1, edges do
						a = rad(90+(2*i-1)*180/edges+self.conf.rotationMesh)
						self.conf.textureArrayCoordinates[#self.conf.textureArrayCoordinates+1] = cX+px[j+indexStartColor]*dimX*cos(a)+deltaX	--x
						self.conf.textureArrayCoordinates[#self.conf.textureArrayCoordinates+1] = cY+py[j+indexStartColor]*dimY*sin(a)+deltaY	--y
					end
				end
			end
			
		end
		self.mesh:setTexture(img)
		self.mesh:setTextureCoordinateArray(self.conf.textureArrayCoordinates)
	end
	
	--position
	self.mesh:setPosition(unpack(self.conf.position))
	self.mesh:setRotation(self.conf.rotation)
	self:addChild(self.mesh)
end


-- clean mesh canvas
function uiGradient:clean()
	
	
	self.mesh:clearIndexArray()
	if self.conf.colorOn then self.mesh:clearColorArray() end
	
	if next(self.conf.texture)==nil then
		self.mesh:clearTextureCoordinateArray()
		self.mesh:clearTexture(self.conf.texture.slot or 0) 
		self.conf.textureArrayCoordinates={}
	end
	
	--empty tables
	self.vertexArray= {}
	self.indexArray = {}
	self.colorArray = {}
	
	self.conf.perX={}
	self.conf.perY={}
	
	self.mesh:removeFromParent()
	
end



function uiGradient:rectangle(conf)
--[[

	-- Procedural grid
	-- http://catlikecoding.com/unity/tutorials/procedural-grid/

	1-----2-----3
    	|\    |\    |				
    	| \   | \   |
	|  \  |  \  |
	|   \ |   \ |
	4-----5-----6
	|\    |\    |				
    	| \   | \   |
	|  \  |  \  |
	|   \ |   \ |
	7-----8-----9
	
	
	Index Array:
	------------------
	1	2	5
	1	5	4
	2	3	6
	2	6	5
	------------------
	4	5	8
	4	8	7
	5	6	9
	5	9	8
	------------------
]]
	----------------------------------------------------------------
	-- update self.conf={}
	----------------------------------------------------------------
	self:setup(conf)
	
	----------------------------------------------------------------
	-- setup variables
	----------------------------------------------------------------
	local colors, alphas, dim = uiGradient:way(self.conf)
	local xSize, ySize = #self.conf.color, #self.conf.color		-- same size but vertex numbers defined vertex
	local vi, a2 = 1, 0

	--squads
	for y=1,ySize-1 do
		for x=1,xSize-1 do
			--print(x.."-"..y..": ", vi, vi+1,		vi+xSize+1)	-- first triangle
			--print(x.."-"..y..": ", vi, vi+xSize+1,	vi+xSize)	-- second triangle
			
			a2 = vi + xSize + 1						--(2)
			
			--first triangle
			self.indexArray[#self.indexArray+1] = vi			--(1)
			self.indexArray[#self.indexArray+1] = vi+1
			self.indexArray[#self.indexArray+1] = a2			--(2)
			
			--second triangle
			self.indexArray[#self.indexArray+1] = vi			--(1)
			self.indexArray[#self.indexArray+1] = a2			--(2)
			self.indexArray[#self.indexArray+1] = a2-1			--vi+xSize+1
			
			vi=vi+1
			
		end
		--print("===============")
		vi=vi+1
	end
	--print("number index:", #self.indexArray)
	--print("number triangle:", (1+1)*(xSize-1)*(ySize-1))
	-----------------------------------
	-- vertexArray
	-- colorArray
	-----------------------------------
	-- rectangle's anchor points are {.5,.5} by default
	-----------------------------------
	local px, py = self.conf.perX, self.conf.perY
	table.insert(px,1,0)
	table.insert(py,1,0)
	self.conf.perX, self.conf.perY = px, py
	
	local dimX, dimY = dim[1], dim[2]
	self.conf.dimension = dim
	local aX, aY	 = self.conf.anchor[1], self.conf.anchor[2]
	for j=1, ySize do		
		for i=1, xSize do	
			----------------------------------------------
			-- vertex
			----------------------------------------------
			--print("vertex:",(px[i]-aX)*dimX, (py[j]-aY)*dimY)
			self.vertexArray[#self.vertexArray+1] = (px[i]-aX)*dimX
			self.vertexArray[#self.vertexArray+1] = (py[j]-aY)*dimY
			
			
			if self.conf.way == "lr" or self.conf.way == "rl" then
				----------------------------------------------
				-- horizontal gradient
				----------------------------------------------
				--print("vertical",colors[i], alphas[i])
				self.colorArray[#self.colorArray+1] = colors[i]
				self.colorArray[#self.colorArray+1] = alphas[i]
				
			else
				
				----------------------------------------------
				-- vertical gradient
				----------------------------------------------
				--print("horizontal",colors[j], alphas[j])
				self.colorArray[#self.colorArray+1] = colors[j]
				self.colorArray[#self.colorArray+1] = alphas[j]
				
			end
		end
		--print("-------------------")
	end
	
	---------------------------------------------------
	-- draw canvas mesh
	---------------------------------------------------
	self.conf.fromFunction = "rectangle"
	self:draw(self.conf)
end


function uiGradient:circle(conf)
	local conf = conf
	conf.edges = conf.edges or 54			--(!!!) circle function call regular polygon function so it works with 54 edge
							---but you can up quantity edges if you need a rendering best
	conf.dimension = {conf.radius,conf.radius}
	self:regularPolygon(conf)
end




function uiGradient:regularPolygon(conf)
	
	----------------------------------------------------------------
	-- update self.conf={}
	----------------------------------------------------------------
	local conf = conf
	conf.way = conf.way or "co"	--gradient from center to outside
	conf.radialGradient = true
	conf.dimension = {conf.radius, conf.radius}
	conf.dimHole = {conf.rI}
	if conf.way=="oc" then conf.color=reverse(conf.color) end
	self:setup(conf)	
	
	----------------------------------------------------------------
	-- setup variables
	----------------------------------------------------------------
	local colors, alphas = uiGradient:way(self.conf) --self.conf.color, self.conf.alpha
	if #colors~=#alphas then print("ERROR! must have the same quantity alphas",#alphas,"and color",#colors ,"array"); return end
	if self.conf.jaggedFree then
		colors[#colors+1] = colors[#colors]
		alphas[#alphas+1] = 0
		if self.conf.hole then
			table.insert(colors,1,colors[1])
			table.insert(alphas,1, 0)
		end
	end
	
	local edges, a, r = self.conf.edges, 0, self.conf.radius
	local cX, cY = unpack(self.conf.center)
	local pX, pY = self.conf.perX, self.conf.perY
	local sX, sY = unpack(self.conf.scalePolygon)
	
	---------------------------------------------------
	-- antializing
	---------------------------------------------------
	local adj = 2					--(!!!) width of degraded:its nice (value 2) but you can up this value according to your requires
	if self.conf.jaggedFree then
		
		pX[#pX], pY[#pY]=(r-adj)/r,(r-adj)/r
		pX[#pX+1], pY[#pY+1] = 1, 1
		
		if conf.hole then
			table.insert(colors,#colors,colors[#colors])
			table.insert(alphas,#alphas,0)
			table.insert(pX,1,pX[1]); table.insert(pY,1,pY[1])
			
			pX[1], pY[1] = pX[2]-adj/r, pX[2]-adj/r
			
		end
	else
		if conf.hole then
			table.insert(colors,#colors,colors[#colors])
			table.insert(alphas,#alphas,1)
		end
		
	end

	---------------------------------------------------
	-- vertex center
	---------------------------------------------------
	local indexStartColor = 1	--	1:hole, 0:not hole
	if not conf.hole then
		indexStartColor = 0
		
		-- center
		self.vertexArray[#self.vertexArray+1] = cX	--x
		self.vertexArray[#self.vertexArray+1] = cY	--y
		self.colorArray[#self.colorArray+1] = colors[1]
		self.colorArray[#self.colorArray+1] = alphas[1]
		
		
		local ii
		for ins=1, edges do
			ii = ins + 2 - indexStartColor
			
			self.indexArray[#self.indexArray+1] = 1			--center
			self.indexArray[#self.indexArray+1] = ii - 1
			self.indexArray[#self.indexArray+1] = edges == ins and 2 or ii
		end
	end


	---------------------------------------------------
	-- vertex out
	---------------------------------------------------
	for j=1-indexStartColor, #pX-indexStartColor do
		for i=1, edges do
			a = rad(90+(2*i-1)*180/edges+self.conf.rotationMesh)

			self.vertexArray[#self.vertexArray+1] = cX + sX*pX[j+indexStartColor]*r*cos(a)	--x
			self.vertexArray[#self.vertexArray+1] = cY + sY*pY[j+indexStartColor]*r*sin(a)	--y
			
			self.colorArray[#self.colorArray+1] = colors[j+1]
			self.colorArray[#self.colorArray+1] = alphas[j+1]
			
		end
	end
	
	
	---------------------------------------------------
	-- grid
	---------------------------------------------------
	if #colors>2 then
		local v1,v2,v3
		local loop = max(1,#colors-2)
		for j=1, loop do
			for ins=1, edges do
				ii = ins + j*edges + 1 
				v1 = ii - edges 
				v2 = edges == ins and v1+1-edges or v1+1
				v3 = ins == edges and ii or v2+edges-1
				
				v1, v2, v3 = v1-indexStartColor, v2-indexStartColor, v3-indexStartColor
				
				self.indexArray[#self.indexArray+1] = v1
				self.indexArray[#self.indexArray+1] = v2
				self.indexArray[#self.indexArray+1] = v2+edges
				
				self.indexArray[#self.indexArray+1] = v1 	
				self.indexArray[#self.indexArray+1] = v2+edges 
				self.indexArray[#self.indexArray+1] = v3 
				
			end
		end
	end

	---------------------------------------------------
	-- draw canvas mesh
	---------------------------------------------------
	self.conf.perX, self.conf.perY = pX, pY
	self.conf.dimension = {r,r}
	self.conf.fromFunction = "regularPolygon"
	self:draw(self.conf)
end


--------------------------------------------------
-- new functionalities coming soon ;)
--------------------------------------------------
function uiGradient:line() end
function uiGradient:convexPolygon() end


--	vertical or horizontal
function uiGradient:way(conf)

	local c, a, d = conf.color, conf.alpha, conf.dimension
	if conf.way=="lr" then 				-- from left to right
		return c, a, d
	elseif conf.way=="rl" then 			-- from right to left
		return reverse(c), reverse(a), d
	elseif conf.way=="bt" then 			-- from bottom to top
		return reverse(c), reverse(a), d
	else						-- from top to bottom
		return c, a, d
	end

end


return uiGradient
