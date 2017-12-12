
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
	Date: Dec 5th, 2017
	
	THIS PROGRAM is developed by Hubert Ronald
	https://sites.google.com/view/liasoft/home
	Feel free to distribute and modify code,
	but keep reference to its creator
	The MIT License (MIT)
	
	Copyright (C) 2017 Hubert Ronald
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
	version 1.0.0			|		dic.06.2017
	---------------------------------------------
	CLASS: uiGradient
	---------------------------------------------
	
--]]
-------------------------
--helper math function
-------------------------
local sin = math.sin
local cos = math.sin
local tan = math.tan
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


-- draw mesh canvas
function uiGradient:draw(conf)
	
	--vertex, index, color
	self.mesh:setVertexArray(unpack(self.vertexArray))
	self.mesh:setIndexArray(unpack(self.indexArray))
	self.mesh:setColorArray(unpack(self.colorArray))
	
	-- texture
	if #self.conf.texture>0 then
		local d = conf.dimension
		local img = Texture.new(unpack(self.conf.texture))
		local tw,th = img:getWidth(),img:getHeight()
		
		local xSize, ySize	= #conf.color, #conf.color
		local px, py	 	= conf.perX, conf.perY
		local dimX, dimY 	= d[1], d[2]
		-----------------------
		-- fix nul space
		-----------------------
		conf.scaleTexture[1] = max(conf.scaleTexture[1],dimX/tw)
		conf.scaleTexture[2] = max(conf.scaleTexture[2],dimY/th)
		
		local dimX, dimY 	= dimX/conf.scaleTexture[1], dimY/conf.scaleTexture[2]
		local dx, dy	 	= tw-dimX, th-dimY
		local aX, aY	 	= conf.anchorTexture[1], conf.anchorTexture[2]
		
		if next(self.conf.textureArrayCoordinates)== nil then
			for j=1, ySize do		
				for i=1, xSize do	
					----------------------------------------------
					-- vertex
					----------------------------------------------
					self.conf.textureArrayCoordinates[#self.conf.textureArrayCoordinates+1] = dimX*px[i]+aX*dx	--vertex X
					self.conf.textureArrayCoordinates[#self.conf.textureArrayCoordinates+1] = dimY*py[j]+aY*dy	--vertex Y
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
	
	self.mesh:clearColorArray()
	self.mesh:clearIndexArray()
	
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
	------------
	1	2	5
	1	5	4
	2	3	6
	2	6	5
	---------------
	4	5	8
	4	8	7
	5	6	9
	5	9	8
	------------
]]
	self.conf={
		----------------------------------------------------------------------
		-- color info
		----------------------------------------------------------------------
		color = {"0xfcfcfc","0xfcfcfc"},	-- colors are like edge: minimum 2 colors
		alpha = {},					-- if {} you want equal quantity alpha: 1 by default
									-- quantity alphas by each color, for example {.5, .8} by two colors
		
		----------------------------------------------------------------------
		-- These paramentes are in Version Aplha in this moment
		----------------------------------------------------------------------
		alphaGrandient = false,		-- if it's true so alpha'll fall porportionally
		perX = {}, 					-- quantity by each color "not alpha":
									-- if {} you want equal quantity colors - 1
									-- cumulative percentaje (max number One) or .
									-- Sample: 0.2, 0.4, 0.6, 0.9, 1 never start ZERO!!!
		perY = {},					-- quantity by each color "not alpha":
									-- if {} you want equal quantity colors - 1
									-- cumulative percentaje (max number One) or .
									-- Sample: 0.2, 0.4, 0.6, 0.9, 1 never start ZERO!!!
		
		----------------------------------------------------------------------
		-- geometry info
		----------------------------------------------------------------------
		anchor = {.5, .5},				
		dimension = {128,128},
		position = {320/2,480/2},
		rotation = 0,
		way = "tb",					-- from top to bottom also: "bt", "lr" and "rl" -- Orientation: Portrait
		
		----------------------------------------------------------------------
		--texture info
		----------------------------------------------------------------------
		texture = {},				-- if {} you don't want this option
									-- or ike always	{"image.png", false, {transparentColor = 0xff00ff}}
									--					{"image.png", true, {wrap = Texture.REPEAT}}
									-- Pixel Data		{nil,300,400;, false, {extend=false}}
		anchorTexture = {.5,.5},		
		scaleTexture = {1,1},		-- scaleX, scaleY
		textureArrayCoordinates={}	-- empty
		
	}
	
	--update config parameters
	if conf then for k,v in pairs(conf) do self.conf[k] = v end end
	
	if next(self.conf.perX)==nil then for k=1, #self.conf.color-1 do self.conf.perX[#self.conf.perX+1]=k/(#self.conf.color-1) end end
	if next(self.conf.perY)==nil then for k=1, #self.conf.color-1 do self.conf.perY[#self.conf.perY+1]=k/(#self.conf.color-1) end end
	
	if next(self.conf.alpha)==nil then
		for k,_ in pairs(self.conf.color) do
			if self.conf.alphaGrandient then
				self.conf.alpha[#self.conf.alpha+1] = (#self.conf.color-k+1)/#self.conf.color
			else
				self.conf.alpha[#self.conf.alpha+1]=1
			end
		end
	end
	
	----------------------------------------------------------------
	-- setup variables
	----------------------------------------------------------------
	local colors, alphas, dim = uiGradient:way(self.conf)
	local xSize, ySize = #self.conf.color, #self.conf.color		-- same size but vertex numbers defined vertex
	local vi, a2 = 1, 0

	--squads
	for y=1,ySize-1 do
		for x=1,xSize-1 do
			--print(x.."-"..y..": ", vi, vi+1,		vi+xSize+1)				-- first triangle
			--print(x.."-"..y..": ", vi, vi+xSize+1,	vi+xSize)				-- second triangle
			
			a2 = vi + xSize + 1								--(2)
			
			--first triangle
			self.indexArray[#self.indexArray+1] = vi		--(1)
			self.indexArray[#self.indexArray+1] = vi+1
			self.indexArray[#self.indexArray+1] = a2		--(2)
			
			--second triangle
			self.indexArray[#self.indexArray+1] = vi		--(1)
			self.indexArray[#self.indexArray+1] = a2		--(2)
			self.indexArray[#self.indexArray+1] = a2-1		--vi+xSize+1
			
			vi=vi+1

			
		end
		--print("==========")
		vi=vi+1
	end
	
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
	end
	
	-- draw canvas mesh
	self:draw(self.conf)
end


function uiGradient:line()


end


function uiGradient:circle()


end


function uiGradient:polygon()


end

--	vertical or horizontal
function uiGradient:way(conf)

	local c, a, d = conf.color, conf.alpha, conf.dimension
	if conf.way=="lr" then 	-- from left to right
		return c, a, d
	elseif conf.way=="rl" then -- from right to left
		return reverse(c), reverse(a), d
	elseif conf.way=="bt" then -- from bottom to top
		return reverse(c), reverse(a), d
	else				-- from top to bottom
		return c, a, d
	end

end


return uiGradient
