--------------------------------------------------------------------------------
-- Legacy face texture mask
--
-- Project setup:
--   Scale mode: No Scale Top Left
--   Logical size: 320 x 480
--   Orientation: Landscape left
--
-- This example maps a portrait texture over regular hexagon meshes.
-- It shows texture masking, mesh rotation, soft vertex tinting,
-- and antialiased polygon edges.
--------------------------------------------------------------------------------

print("\n")

application:setOrientation(Application.LANDSCAPE_LEFT)

-- Soft neutral background for README screenshots.
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
local FACE_TEXTURE = ASSET_PATH .. "peruvianModel_Maju_001.png"

--------------------------------------------------------------------------------
-- Palette
--
-- Very soft editorial tint.
-- The alpha is high because texture + colorOn=true also affects
-- the portrait visibility.
--------------------------------------------------------------------------------

local SOFT_FACE_TINT = {
	0xffffff, -- preserve face detail
	0xf1f5f9, -- soft light gray
	0xdbeafe, -- pale blue
	0x94a3b8  -- soft slate edge
}

local SOFT_FACE_ALPHA = {
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

-- Keep the portrait large but not cropped by the screenshot bounds.
local radius = math.min(_W * 0.20, _H * 0.42, 245)

-- Smaller spacing than before.
-- This keeps both shapes visually grouped like the original dark-background demo.
local spacing = radius * 1.08

--------------------------------------------------------------------------------
-- Helper
--------------------------------------------------------------------------------

local function addHexagonFaceMask(conf)
	local mesh = GradientMesh.new()

	mesh:circle({
		-- True regular hexagon.
		edges = 6,
		radius = conf.radius or radius,

		-- Center to outside. Keeps the soft/light color near the face center.
		way = conf.way or "co",

		color = conf.color or SOFT_FACE_TINT,
		alpha = conf.alpha or SOFT_FACE_ALPHA,

		position = conf.position,
		rotationMesh = conf.rotationMesh or 0,
		scalePolygon = conf.scalePolygon or {1, 1},

		texture = {conf.texture or FACE_TEXTURE, true},

		-- Crop controls for peruvianModel_Maju_001.png.
		anchorTexture = conf.anchorTexture or {0.54, 0.50},
		scaleTexture = conf.scaleTexture or {1, 1},

		-- Keep false for portraits. A hole cuts the face center.
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

-- Left: regular hexagon portrait mask.
addHexagonFaceMask({
	position = {centerX - spacing, centerY},
	rotationMesh = 0,
	anchorTexture = {0.54, 0.50}
})

-- Right: rotated hexagon portrait mask.
addHexagonFaceMask({
	position = {centerX + spacing, centerY},
	rotationMesh = 30,
	anchorTexture = {0.54, 0.50}
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
--   SOFT_FACE_TINT = {0xffffff, 0xf1f5f9, 0xdbeafe, 0x64748b}
--   SOFT_FACE_ALPHA = {1.00, 0.98, 0.94, 0.90}
--
-- More visible portrait / less tint:
--   SOFT_FACE_ALPHA = {1.00, 1.00, 0.98, 0.94}
--------------------------------------------------------------------------------