--------------------------------------------------------------------------------
-- Texture masking over rotated regular polygon meshes
--
-- Project setup:
--   Scale mode: No Scale Top Left
--   Logical size: 320 x 480
--   Orientation: Landscape left
--
-- This example maps a portrait texture over two regular polygon meshes:
--   1. square mesh
--   2. rotated square mesh / diamond mesh
--
-- The goal is to show texture masking, mesh rotation, vertex color tinting,
-- and antialiased polygon edges in a clean documentation-friendly scene.
--------------------------------------------------------------------------------

print("\n")

application:setOrientation(Application.LANDSCAPE_LEFT)

-- Neutral documentation-friendly background.
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

local ASSET_PATH = "assets/images/legacy-faces/"
local FACE_TEXTURE = ASSET_PATH .. "ariel-lustre-208615.png"

--------------------------------------------------------------------------------
-- Palette
--
-- Soft neutral-blue tint.
-- With texture + colorOn=true, alpha also affects texture visibility.
--------------------------------------------------------------------------------

local PORTRAIT_TINT = {
	0xffffff, -- center / preserves face detail
	0xf1f5f9, -- soft neutral light
	0xdbeafe, -- pale blue
	0x94a3b8  -- soft slate edge
}

local PORTRAIT_ALPHA = {
	1.00,
	0.98,
	0.94,
	0.88
}

--------------------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------------------

local centerX = _W / 2
local centerY = _H / 2

local radius = math.min(_W * 0.20, _H * 0.38, 230)

-- Compact spacing, closer to the original dark-background composition.
local spacing = radius * 1.08

--------------------------------------------------------------------------------
-- Helper
--------------------------------------------------------------------------------

local function addTextureMask(conf)
	local mesh = GradientMesh.new()

	mesh:circle({
		-- Four edges create a square. The rotated variant becomes a diamond.
		edges = conf.edges or 4,
		radius = conf.radius or radius,

		-- "co" keeps the first color closer to the center and the last color
		-- toward the outer ring.
		way = conf.way or "co",

		color = conf.color or PORTRAIT_TINT,
		alpha = conf.alpha or PORTRAIT_ALPHA,

		position = conf.position,
		rotationMesh = conf.rotationMesh or 0,
		scalePolygon = conf.scalePolygon or {1, 1},

		texture = {conf.texture or FACE_TEXTURE, true},

		-- Crop controls for ariel-lustre-208615.png.
		anchorTexture = conf.anchorTexture or {0.50, 0.50},
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

-- Square texture mask.
addTextureMask({
	position = {centerX - spacing, centerY},
	rotationMesh = 0,
	anchorTexture = {0.50, 0.50},
	scaleTexture = {1, 1}
})

-- Rotated square / diamond texture mask.
addTextureMask({
	position = {centerX + spacing, centerY},
	rotationMesh = 45,
	anchorTexture = {0.50, 0.50},
	scaleTexture = {1, 1}
})

--------------------------------------------------------------------------------
-- Tuning
--
-- Bring them even closer:
--   local spacing = radius * 0.98
--
-- Separate them a little more:
--   local spacing = radius * 1.18
--
-- Stronger edge contrast:
--   PORTRAIT_TINT = {0xffffff, 0xf1f5f9, 0xdbeafe, 0x64748b}
--   PORTRAIT_ALPHA = {1.00, 0.98, 0.94, 0.90}
--
-- Hexagon variant:
--   edges = 6
--   rotationMesh = 30
--------------------------------------------------------------------------------