--------------------------------------------------------------------------------
-- Radial shapes, holes, and deformation
--
-- Project setup:
--   Scale mode: No Scale Top Left
--   Logical size: 320 x 480
--   Orientation: Landscape left
--
-- This example uses a fixed 480 x 320 landscape canvas so the exported
-- documentation screenshot is stable and all three shapes remain visible.
--------------------------------------------------------------------------------

print("\n")

application:setOrientation(Application.LANDSCAPE_LEFT)

--------------------------------------------------------------------------------
-- Fixed logical canvas for documentation screenshots
--------------------------------------------------------------------------------

local LOGICAL_W = 480
local LOGICAL_H = 320

application:setLogicalDimensions(LOGICAL_W, LOGICAL_H)

_W = application:getLogicalWidth()
_H = application:getLogicalHeight()

Wdx = application:getLogicalTranslateX() / application:getLogicalScaleX()
Hdy = application:getLogicalTranslateY() / application:getLogicalScaleY()

print("Logical size:", _W, _H)

--------------------------------------------------------------------------------
-- Solid documentation background
--
-- This makes donut holes and transparent antialiasing rings resolve against
-- the same color used by application:setBackgroundColor.
--------------------------------------------------------------------------------

local BACKGROUND_COLOR = 0xf4f6f8

application:setBackgroundColor(BACKGROUND_COLOR)

local background = Shape.new()
background:setFillStyle(Shape.SOLID, BACKGROUND_COLOR, 1)
background:beginPath()
background:moveTo(0, 0)
background:lineTo(_W, 0)
background:lineTo(_W, _H)
background:lineTo(0, _H)
background:closePath()
background:endPath()
stage:addChild(background)


--------------------------------------------------------------------------------
-- Dependencies
--------------------------------------------------------------------------------

local GradientMesh = require "src/gradient_mesh"

--------------------------------------------------------------------------------
-- Helpers
--
-- gradient_mesh.lua mutates color/alpha arrays internally when using
-- radial polygons, jaggedFree, and "oc" direction.
-- Therefore each mesh must receive fresh array copies.
--------------------------------------------------------------------------------

local function cloneArray(source)
	local copy = {}

	for i = 1, #source do
		copy[i] = source[i]
	end

	return copy
end

--------------------------------------------------------------------------------
-- Palettes
--
-- Cool / geometric / technical.
-- The outer colors are intentionally light to avoid dark antialias borders.
--------------------------------------------------------------------------------


local PALETTES = {
	ellipse = {
		0x334155, -- soft slate center 
		0x6366f1, -- indigo 
		0x93c5fd, -- blue 
		0xe0f2fe -- pale blue edge
	},

	circle = {
		0x1e3a8a, -- deep blue center
		0x3b82f6, -- blue
		0x7dd3fc, -- sky
		0xf0f9ff -- pale sky edge
	},

	donut = {
		0x0f766e, -- teal center/ring
		0x14b8a6, -- teal
		0x99f6e4, -- mint
		0xecfeff -- pale cyan edge
	}
}

local ALPHA_SOLID = {
	1.00,
	1.00,
	0.97,
	0.90
}

--------------------------------------------------------------------------------
-- Layout
--
-- Explicit positions for a 480 x 320 logical canvas.
-- The ellipse is wider than the circle because of scalePolygon,
-- so it needs more horizontal room.
--------------------------------------------------------------------------------

local centerY = 160
local radius = 56

local ellipsePosition = {110, centerY}
local circlePosition  = {255, centerY}
local donutPosition   = {380, centerY}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function addRadialShape(conf)
	local mesh = GradientMesh.new()

	mesh:regularPolygon({
		edges = conf.edges or 96,
		radius = conf.radius or radius,

		-- Use "co" to keep the palette order stable:
		-- first color near the center, last color near the outer edge.
		way = conf.way or "co",

		color = cloneArray(conf.color),
		alpha = cloneArray(conf.alpha or ALPHA_SOLID),

		position = conf.position,
		scalePolygon = conf.scalePolygon or {1, 1},
		rotationMesh = conf.rotationMesh or 0,

		hole = conf.hole or false,
		rIn = conf.rIn or 0,

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

-- 1. Deformed radial ellipse.
addRadialShape({
	edges = 96,
	radius = radius,
	way = "co",
	color = PALETTES.ellipse,
	alpha = ALPHA_SOLID,
	position = ellipsePosition,
	scalePolygon = {1.25, 0.72},
	hole = false
})

-- 2. Clean circular radial gradient.
addRadialShape({
	edges = 120,
	radius = radius,
	way = "co",
	color = PALETTES.circle,
	alpha = ALPHA_SOLID,
	position = circlePosition,
	scalePolygon = {1, 1},
	hole = false
})

-- 3. Donut / inner hole radial gradient.
addRadialShape({
	edges = 120,
	radius = radius,
	way = "co",
	color = PALETTES.donut,
	alpha = ALPHA_SOLID,
	position = donutPosition,
	scalePolygon = {1, 1},
	hole = true,
	rIn = radius * 0.42
})

--------------------------------------------------------------------------------
-- Tuning
--
-- Bigger shapes:
--   local radius = 62
--
-- Smaller shapes:
--   local radius = 50
--
-- Move shapes closer:
--   ellipsePosition = {130, centerY}
--   circlePosition  = {240, centerY}
--   donutPosition   = {350, centerY}
--
-- Softer look:
--   ALPHA_SOLID = {1.00, 0.96, 0.92, 0.86}
--
-- Stronger look:
--   ALPHA_SOLID = {1.00, 1.00, 0.98, 0.96}
--------------------------------------------------------------------------------