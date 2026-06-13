--------------------------------------------------------------------------------
-- Gradient overlay
--
-- Project setup:
--   Scale mode: No Scale Top Left
--   Logical size: 320 x 480
--   Orientation: Landscape left
--
-- This example loads gradient palettes inspired by uiGradients and applies
-- them over a landscape texture.
--------------------------------------------------------------------------------

print("\n")

application:setOrientation(Application.LANDSCAPE_LEFT)
application:setBackgroundColor(0xf4f6f8)

--------------------------------------------------------------------------------
-- Logical dimensions
--------------------------------------------------------------------------------

local contentW = application:getContentWidth()
local contentH = application:getContentHeight()

application:setLogicalDimensions(contentW, contentH)

_W = application:getLogicalWidth()
_H = application:getLogicalHeight()

Wdx = application:getLogicalTranslateX() / application:getLogicalScaleX()
Hdy = application:getLogicalTranslateY() / application:getLogicalScaleY()

--------------------------------------------------------------------------------
-- Dependencies
--------------------------------------------------------------------------------

local json = nil

pcall(function()
	local mod = require "json"
	if mod then json = mod end
end)

json = json or _G.json

local GradientMesh = require "src/gradient_mesh"

--------------------------------------------------------------------------------
-- Config
--------------------------------------------------------------------------------

local USE_REMOTE_GRADIENTS = true
local SHOW_UI_LABELS = false -- keep false for clean README screenshots

local IMAGE_PATH = "assets/images/landscapes/"
local FONT_PATH = "assets/fonts/"
local LANDSCAPE_TEXTURE = IMAGE_PATH .. "pexels-photo-89432.png"

local REMOTE_GRADIENTS_URL =
	"https://raw.githubusercontent.com/ghosh/uiGradients/master/gradients.json"

local FALLBACK_GRADIENTS = {
	{
		name = "Big Rainbow",
		colors = {0x00f260, 0x0575e6, 0xf7971e, 0xffd200}
	},
	{
		name = "Cosmic Fusion",
		colors = {0xff00cc, 0x333399, 0x00dbde}
	},
	{
		name = "Soft Editorial",
		colors = {0xf8fafc, 0xdbeafe, 0x93c5fd, 0x475569}
	}
}

local gradientWays = {"tb", "bt", "lr", "rl"}
local wayIndex = 1
local gradientIndex = 1

local currentMesh = nil
local textName = nil
local textColors = nil
local textRotate = nil

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function parseHexColor(value)
	if type(value) == "number" then
		return value
	end

	if type(value) == "string" then
		local clean = value:gsub("#", ""):gsub("0x", "")
		return tonumber(clean, 16) or 0xffffff
	end

	return 0xffffff
end

local function normalizeGradients(data)
	local gradients = {}

	if type(data) ~= "table" then
		return FALLBACK_GRADIENTS
	end

	for i = 1, #data do
		local item = data[i]

		if item and item.colors and #item.colors >= 2 then
			local colors = {}

			for j = 1, #item.colors do
				colors[#colors + 1] = parseHexColor(item.colors[j])
			end

			gradients[#gradients + 1] = {
				name = item.name or ("Gradient " .. tostring(i)),
				colors = colors
			}
		end
	end

	if #gradients == 0 then
		return FALLBACK_GRADIENTS
	end

	return gradients
end

local function loadJson(filename)
	if not json then
		return nil
	end

	local path = filename .. ".json"
	local file = io.open(path, "r")

	if not file then
		return nil
	end

	local contents = file:read("*a")
	io.close(file)

	return json.decode(contents)
end

local function colorList(colors)
	local values = {}

	for i = 1, #colors do
		values[#values + 1] = string.format("0x%06X", colors[i])
	end

	return table.concat(values, " -> ")
end

local function clearLabels()
	if textName then
		textName:removeFromParent()
		textName = nil
	end

	if textColors then
		textColors:removeFromParent()
		textColors = nil
	end

	if textRotate then
		textRotate:removeFromParent()
		textRotate = nil
	end
end

local function renderLabels(gradient)
	if not SHOW_UI_LABELS then
		return
	end

	clearLabels()

	local font = TTFont.new(FONT_PATH .. "Roboto-Regular.ttf", 20)
	local smallFont = TTFont.new(FONT_PATH .. "Roboto-Regular.ttf", 14)

	textName = TextField.new(font, gradient.name)
	textName:setTextColor(0xffffff)
	textName:setAlpha(0.95)
	textName:setPosition(_W / 2 - textName:getWidth() / 2, 48)

	textColors = TextField.new(smallFont, colorList(gradient.colors))
	textColors:setTextColor(0xffffff)
	textColors:setAlpha(0.90)
	textColors:setPosition(_W / 2 - textColors:getWidth() / 2, 84)

	textRotate = TextField.new(font, "Rotate Gradient")
	textRotate:setTextColor(0xffffff)
	textRotate:setAlpha(0.90)
	textRotate:setPosition(_W / 2 - textRotate:getWidth() / 2, _H - 42)

	stage:addChild(textName)
	stage:addChild(textColors)
	stage:addChild(textRotate)
end

local function renderGradient(gradient)
	if currentMesh then
		currentMesh:clean()
		currentMesh:removeFromParent()
		currentMesh = nil
	end

	currentMesh = GradientMesh.new()

	local conf = {
		color = gradient.colors,
		alpha = {},

		anchor = {0, 0},
		dimension = {_W, _H},
		position = {0, 0},
		rotation = 0,
		way = gradientWays[wayIndex],

		texture = {LANDSCAPE_TEXTURE, true},
		anchorTexture = {0.20, 0.50},
		scaleTexture = {0, 0},

		deform = false,
		colorOn = true
	}

	currentMesh:rectangle(conf)
	stage:addChild(currentMesh)

	renderLabels(gradient)

	print("\n" .. gradient.name .. ": " .. colorList(gradient.colors))
end

--------------------------------------------------------------------------------
-- Initial render
--------------------------------------------------------------------------------

local gradients = FALLBACK_GRADIENTS

renderGradient(gradients[gradientIndex])

--------------------------------------------------------------------------------
-- Interaction
--------------------------------------------------------------------------------

stage:addEventListener(Event.MOUSE_DOWN, function(e)
	if SHOW_UI_LABELS and textRotate and textRotate:hitTestPoint(e.x, e.y) then
		wayIndex = wayIndex + 1
		if wayIndex > #gradientWays then wayIndex = 1 end

		renderGradient(gradients[gradientIndex])
		e:stopPropagation()
		return
	end

	gradientIndex = gradientIndex + 1
	if gradientIndex > #gradients then gradientIndex = 1 end

	renderGradient(gradients[gradientIndex])
	e:stopPropagation()
end)

--------------------------------------------------------------------------------
-- Remote gradients
--------------------------------------------------------------------------------

if USE_REMOTE_GRADIENTS and json then
	local loader = UrlLoader.new(REMOTE_GRADIENTS_URL)

	local function onComplete(e)
		local out = io.open("|D|data.json", "wb")

		if out then
			out:write(e.data)
			out:close()
		end

		local data = loadJson("|D|data")
		gradients = normalizeGradients(data)

		gradientIndex = math.random(1, #gradients)
		wayIndex = 1

		renderGradient(gradients[gradientIndex])
	end

	local function onError()
		print("Remote gradient load failed. Using fallback gradients.")
	end

	local function onProgress(e)
		print("progress: " .. e.bytesLoaded .. " of " .. e.bytesTotal)
	end

	loader:addEventListener(Event.COMPLETE, onComplete)
	loader:addEventListener(Event.ERROR, onError)
	loader:addEventListener(Event.PROGRESS, onProgress)
end