--------------------------------------------------------------------------------
-- Radial shapes, holes, and deformation
--
-- Project setup:
--   Scale mode: No Scale Top Left
--   Logical size: 320 x 480
--   Orientation: Landscape left
--
-- This example demonstrates radial gradient geometry:
--   1. deformed radial ellipse
--   2. circular radial gradient
--   3. radial gradient with inner hole / donut
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
-- Palettes
--------------------------------------------------------------------------------

local PALETTES = {
	ellipse = {0xe0f2fe, 0x93c5fd, 0x6366f1, 0x334155},
	circle = {0xfffbeb, 0xfde68a, 0xf9a8d4, 0x9333ea},
	donut = {0xecfeff, 0x99f6e4, 0x38bdf8, 0x1e3a8a}
}

local ALPHA_SOLID = {1.00, 0.98, 0.96, 0.92}

--------------------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------------------

local centerX = _W / 2
local centerY = _H / 2

local base = math.min(_W, _H)
local radius = math.min(base * 0.25, 150)
local spacing = radius * 1.48

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function addRadialShape(conf)
	local mesh = GradientMesh.new()

	mesh:regularPolygon({
		edges = conf.edges or 96,
		radius = conf.radius or radius,

		way = conf.way or "co",
		color = conf.color,
		alpha = conf.alpha or ALPHA_SOLID,

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

-- Deformed radial ellipse.
addRadialShape({
	edges = 96,
	radius = radius * 1.02,
	way = "oc",
	color = PALETTES.ellipse,
	position = {centerX - spacing, centerY},
	scalePolygon = {1.35, 0.82},
	hole = false
})

-- Clean circular radial gradient.
addRadialShape({
	edges = 120,
	radius = radius,
	way = "co",
	color = PALETTES.circle,
	position = {centerX, centerY},
	scalePolygon = {1, 1},
	hole = false
})

-- Donut / inner hole radial gradient.
addRadialShape({
	edges = 120,
	radius = radius,
	way = "oc",
	color = PALETTES.donut,
	position = {centerX + spacing, centerY},
	scalePolygon = {1, 1},
	hole = true,
	rIn = radius * 0.42
})

--------------------------------------------------------------------------------
-- Tuning
--
-- More geometric / polygonal look:
--   edges = 6, 8, 12
--
-- Smoother circular look:
--   edges = 96, 120, 160
--
-- Larger hole:
--   rIn = radius * 0.55
--
-- Smaller hole:
--   rIn = radius * 0.30
--------------------------------------------------------------------------------