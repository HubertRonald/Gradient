--------------------------------------------------------------------------------
-- Radial gradient splash masks
--
-- Project setup:
--   Scale mode: No Scale Top Left
--   Logical size: 320 x 480
--   Orientation: Landscape left
--
-- This example combines splash textures with rectangular and radial
-- gradient meshes.
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

local GradientMesh = require "src/gradient_mesh"

--------------------------------------------------------------------------------
-- Assets
--------------------------------------------------------------------------------

local SPLASH_PATH = "assets/images/splashes/"

--------------------------------------------------------------------------------
-- Palettes
--
-- These are intentionally varied so each splash demonstrates a different
-- mood while keeping enough contrast on a light documentation background.
--------------------------------------------------------------------------------

local PALETTES = {
	aurora = {0x22d3ee, 0xa78bfa, 0x475569},
	sunset = {0xffd166, 0xfca5a5, 0xfb7185},
	ocean = {0xbfdbfe, 0x60a5fa, 0x1e3a8a},
	candy = {0xfbcfe8, 0xc4b5fd, 0x7c3aed},
	lime = {0xd9f99d, 0x5eead4, 0x0f766e},
	mist = {0xffffff, 0xe0f2fe, 0x94a3b8}
}

--------------------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------------------

local centerX = _W / 2
local centerY = _H / 2

local base = math.min(_W, _H)
local radius = math.min(base * 0.24, 145)
local gapX = radius * 1.55
local gapY = radius * 1.18

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function addRectangleSplash(conf)
	local texture = Texture.new(SPLASH_PATH .. conf.file, true)
	local scale = conf.scale or 0.45
	local width = texture:getWidth() * scale
	local height = texture:getHeight() * scale

	local mesh = GradientMesh.new()

	mesh:rectangle({
		color = conf.color,
		alpha = conf.alpha or {},

		anchor = {0.5, 0.5},
		dimension = {width, height * (conf.heightRatio or 0.52)},
		way = conf.way or "lr",
		position = conf.position,

		texture = {SPLASH_PATH .. conf.file, true},
		anchorTexture = conf.anchorTexture or {0.5, 0.5},
		scaleTexture = {scale, scale},

		deform = false,
		colorOn = true
	})

	stage:addChild(mesh)

	return mesh
end

local function addRadialSplash(conf)
	local mesh = GradientMesh.new()

	mesh:circle({
		color = conf.color,
		alpha = conf.alpha or {},

		radius = conf.radius or radius,
		edges = conf.edges or 72,
		way = conf.way or "co",
		position = conf.position,

		texture = {SPLASH_PATH .. conf.file, true},
		anchorTexture = conf.anchorTexture or {0.5, 0.5},
		scaleTexture = conf.scaleTexture or {1, 1},

		hole = false,
		jaggedFree = true,
		colorOn = true,
		deform = false
	})

	stage:addChild(mesh)

	return mesh
end

--------------------------------------------------------------------------------
-- Examples
--------------------------------------------------------------------------------

-- Subtle rectangular splash, useful as a UI accent / brush stroke.
addRectangleSplash({
	file = "splashWhite_001.png",
	color = PALETTES.mist,
	way = "lr",
	position = {centerX - gapX, centerY - gapY},
	scale = 0.38,
	heightRatio = 0.50
})

-- Upper middle splash.
addRadialSplash({
	file = "splashWhite_007.png",
	color = PALETTES.ocean,
	radius = radius * 0.82,
	way = "co",
	position = {centerX, centerY - gapY * 0.88}
})

-- Upper right splash.
addRadialSplash({
	file = "splashWhite_005.png",
	color = PALETTES.candy,
	radius = radius * 0.86,
	way = "oc",
	position = {centerX + gapX, centerY - gapY * 0.88}
})

-- Lower left splash.
addRadialSplash({
	file = "splashWhite_003.png",
	color = PALETTES.aurora,
	radius = radius * 1.02,
	way = "oc",
	position = {centerX - gapX * 0.72, centerY + gapY * 0.82}
})

-- Lower center splash.
addRadialSplash({
	file = "splashWhite_009.png",
	color = PALETTES.sunset,
	radius = radius * 0.98,
	way = "co",
	position = {centerX + gapX * 0.22, centerY + gapY * 0.90}
})

-- Lower right splash.
addRadialSplash({
	file = "splashWhite_008.png",
	color = PALETTES.lime,
	radius = radius * 0.82,
	way = "co",
	position = {centerX + gapX * 1.05, centerY + gapY * 0.78}
})

--------------------------------------------------------------------------------
-- Tuning
--
-- More compact layout:
--   local gapX = radius * 1.35
--   local gapY = radius * 1.05
--
-- More spacious layout:
--   local gapX = radius * 1.75
--   local gapY = radius * 1.35
--------------------------------------------------------------------------------