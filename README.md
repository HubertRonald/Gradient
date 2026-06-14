# Gideros Gradient Mesh

<p align="left">
  <img src="https://img.shields.io/badge/Lua-5.x-2C2D72?logo=lua&logoColor=white" alt="Lua">
  <img src="https://img.shields.io/badge/Gideros-Compatible-orange" alt="Gideros Compatible">
  <img src="https://img.shields.io/badge/json-5E5C5C?style=flat-square&logo=json&logoColor=white" alt="Json">
  <img src="https://img.shields.io/github/license/HubertRonald/Gradient" alt="License">
  <a href="https://github.com/HubertRonald/Gradient/issues" target="_blank">
      <img src="https://img.shields.io/badge/issues-open-green?style=flat-square&logo=github" alt="GitHub issues" />
  </a>
  <a href="https://github.com/HubertRonald/Gradient/pulls" target="_blank">
      <img src="https://img.shields.io/badge/pull%20requests-open-yellow?style=flat-square&logo=github" alt="GitHub pull requests" />
  </a>
  <img src="https://img.shields.io/github/last-commit/HubertRonald/Gradient?style=flat-square" />
  <img src="https://img.shields.io/github/commit-activity/t/HubertRonald/Gradient?style=flat-square&color=dodgerblue" />
  <img src="https://img.shields.io/github/stars/HubertRonald/Gradient?style=social" alt="GitHub stars">
  
</p>


<p align="left">
  <strong>Procedural gradient meshes for Gideros, written in Lua.</strong>
</p>

<p align="left">
  <em>Clean gradients, radial meshes, polygon-based color interpolation, texture masking, and playful visual experiments for 2D creative coding.</em>
</p>


---

## Overview

**Gideros Gradient Mesh** is a small Lua utility for creating procedural gradients using the `Mesh` API in [Gideros](https://github.com/gideros/gideros).

It was originally built as a lightweight visual experiment inspired by gradient palettes such as GradientMeshs, but the core idea is more technical: instead of drawing a flat bitmap gradient, the library builds a mesh, assigns colors to vertices, and lets the renderer interpolate those colors across triangles.

The result is a compact, reusable snippet for:

* gradient cards and backgrounds;
* radial color fields;
* regular polygons;
* circles and ellipse-like shapes;
* textured gradient masks;
* experimental 2D visual effects.

---
## Preview

The examples below show two main use cases for **Gideros Gradient Mesh**: applying procedural gradients over image textures, and generating clean gradient-based background shapes directly from mesh geometry.

### Gradient overlays

These examples use a source image as a texture and blend it with a generated gradient mesh. This is useful for hero images, game menus, splash screens, atmospheric backgrounds, and visual experiments where the image should keep its structure while gaining a stronger color mood.

<p align="center">
  <img src="assets/images/landscapes/pexels-photo-89432.png" width="32%" alt="Original landscape image">
  <img src="docs/images/gradient-mesh-big-rainbow.png" width="32%" alt="Landscape image with Big Rainbow gradient overlay">
  <img src="docs/images/gradient-mesh-big-rainbow-fog.png" width="32%" alt="Landscape image with soft Big Rainbow Fog gradient overlay">
</p>

### Gradient backgrounds and shapes

These examples focus on pure gradient surfaces generated with mesh vertices and interpolated colors. They are useful for UI cards, menu backgrounds, decorative panels, abstract scenes, and quick visual prototyping inside Gideros.

<p align="center">
  <img src="docs/images/gradient-mesh-royal-blue.png" width="32%" alt="Royal Blue gradient mesh background">
  <img src="docs/images/gradient-mesh-firewatch.png" width="32%" alt="Firewatch gradient mesh background">
  <img src="docs/images/gradient-mesh-mango.png" width="32%" alt="Mango gradient mesh background">
</p>

> These screenshots are generated examples. For a cleaner portfolio presentation, the visuals are intentionally kept simple: the image carries the gradient result, while names and descriptions live in the README instead of being embedded inside the screenshots.

---

## Visual examples

The examples below are grouped by rendering feature. Each screenshot is generated from a dedicated Gideros example script, so the visual documentation stays reproducible and easier to maintain.

### Gradient overlays

This example applies procedural gradient colors over a landscape texture. It is useful for hero images, game menus, splash screens, atmospheric backgrounds, and quick mood exploration.

<p align="center">
  <img src="docs/images/gradient-overlay-landscape.png" width="70%" alt="Landscape image with procedural gradient mesh overlay">
</p>

Generated from:

```lua
require "examples/gradient_overlay"
```

### Texture masking over rotated polygon meshes

Gideros Gradient Mesh can map an image texture onto polygon-based mesh geometry. This makes it possible to clip, rotate, tint, and antialias images using mesh vertices instead of pre-rendered bitmap masks.

<p align="center">
  <img src="docs/images/texture-mask-rotated-mesh.png" width="70%" alt="Texture mask over square and rotated polygon mesh">
</p>

Generated from:

```lua
require "examples/texture_mask_rotated_mesh"
```

### Hexagon portrait texture masking

This example maps a portrait texture onto regular hexagon meshes. It shows how the same portrait can be clipped through polygon geometry while preserving the image and adding a subtle vertex-color tint.

<p align="center">
  <img src="docs/images/hexagon-portrait-texture-mask.png" width="70%" alt="Portrait texture masked through regular hexagon meshes">
</p>

Generated from:

```lua
require "examples/hexagon_portrait_texture_mask"
```

### Radial shapes, holes, and deformation

Radial gradients are generated by creating rings of vertices around a center point. By changing the number of edges, scale factors, and inner radius, the same algorithm can produce circles, ellipses, polygons, donuts, and deformed radial shapes.

<p align="center">
  <img src="docs/images/radial-shapes-hole-deform.png" width="70%" alt="Radial gradient shapes with hole and deformation">
</p>

Generated from:

```lua
require "examples/radial_shapes_hole_deform"
```

### Splash texture masks

Splash examples combine texture masks with radial color interpolation. This is useful for expressive backgrounds, particle-like effects, menu accents, and creative coding experiments.

<p align="center">
  <img src="docs/images/radial-gradient-splash-masks.png" width="70%" alt="Radial gradient splash texture masks">
</p>

Generated from:

```lua
require "examples/radial_gradient_splash_masks"
```


---

## Example map

| Example | Focus | Output |
| --- | --- | --- |
| `gradient_overlay.lua` | Gradient overlay over texture | `docs/images/gradient-overlay-landscape.png` |
| `texture_mask_rotated_mesh.lua` | Square and rotated-square texture masking | `docs/images/texture-mask-rotated-mesh.png` |
| `hexagon_portrait_texture_mask.lua` | Portrait texture masking over hexagonal meshes | `docs/images/hexagon-portrait-texture-mask.png` |
| `radial_shapes_hole_deform.lua` | Radial shapes, holes, and deformation | `docs/images/radial-shapes-hole-deform.png` |
| `radial_gradient_splash_masks.lua` | Splash texture masks with radial gradients | `docs/images/radial-gradient-splash-masks.png` |

`main.lua` works as a simple sample launcher. Uncomment the sample you want to run:

```lua
--------------------------------------------------------------------------------
-- Gideros Gradient Mesh examples
--------------------------------------------------------------------------------

-- require "examples/gradient_overlay"
-- require "examples/texture_mask_rotated_mesh"
-- require "examples/hexagon_portrait_texture_mask"
-- require "examples/radial_shapes_hole_deform"
require "examples/radial_gradient_splash_masks"
```

---

## Features

A usual 2D gradient can be treated as a color interpolation problem.
**Gideros Gradient Mesh** approaches that problem geometrically: it creates vertices, assigns colors to those vertices, and lets the renderer interpolate color values across triangles.

For a rectangular gradient, the mesh is built as a regular grid:

```txt
v1 ----- v2 ----- v3
 | \      | \      |
 |  \     |  \     |
v4 ----- v5 ----- v6
 | \      | \      |
 |  \     |  \     |
v7 ----- v8 ----- v9
```

Each grid cell is split into two triangles:

```txt
(v1, v2, v5)
(v1, v5, v4)
```

If a rectangle has width $w$, height $h$, and anchor point $(a_x, a_y)$, a vertex at normalized grid coordinates $(u_i, v_j)$ can be written as:

$$
P_{ij} =
\left(
(u_i - a_x)w,
(v_j - a_y)h
\right)
$$

For each cell, the two triangles can be represented as:

$$
T_1 = (P_{ij}, P_{i+1,j}, P_{i+1,j+1})
$$

$$
T_2 = (P_{ij}, P_{i+1,j+1}, P_{i,j+1})
$$

Inside a triangle, the renderer interpolates vertex colors. Conceptually, a simple two-color gradient can be written as:

$$
C(t) = (1 - t)C_0 + tC_1
$$

Where:

$$
0 \leq t \leq 1
$$

For a triangle, this idea generalizes through barycentric interpolation. If a point inside a triangle has barycentric weights (\lambda_1), (\lambda_2), and (\lambda_3), then:

$$
\lambda_1 + \lambda_2 + \lambda_3 = 1
$$

and the interpolated color is:

$$
C(P) = \lambda_1 C_1 + \lambda_2 C_2 + \lambda_3 C_3
$$

That is the small trick behind the visual result: the Lua code builds the geometry, while the rendering pipeline does the smooth color blending.

---

## Radial and polygon gradients

For circular and polygon-based gradients, the library creates rings of vertices around a center point.

A radial vertex can be described as:

$$
P_{ij} =
\left(
c_x + s_x,p^x_j,r\cos(\theta_i),
c_y + s_y,p^y_j,r\sin(\theta_i)
\right)
$$

Where:

* $(c_x, c_y)$ is the center point;
* $s_x$ and $s_y$ are scale factors from `scalePolygon`;
* $r$ is the base radius;
* $p^x_j$ and $p^y_j$ are normalized radial percentages for the current color stop;
* $\theta_i$ is the angular position of the current polygon vertex.

For a regular polygon with $n$ edges, the angle of each vertex is:

$$
\theta_i =
\frac{\pi}{2}
+
\frac{(2i - 1)\pi}{n}
+
\rho
$$

Where $\rho$ is the mesh rotation angle coming from `rotationMesh`.

This is why the same function can produce circles, ellipses, regular polygons, rotated polygons, and radial texture masks: changing $n$, $r$, $s_x$, $s_y$, and $\rho$ changes the generated mesh.

### Inner holes

When `hole = true`, the radial mesh starts from an inner radius instead of the center. If $r_{\text{in}}$ is the inner radius and $r$ is the outer radius, the normalized inner position is:

$$
p_{\text{in}} = \frac{r_{\text{in}}}{r}
$$

For multiple radial color stops, the intermediate percentages can be distributed between the inner and outer radius:

$$
p_j =
\frac{r_{\text{in}}}{r}
+
j \cdot
\frac{r - r_{\text{in}}}{m r}
$$

Where $m$ is the number of color stops.

This creates donut-like gradients and ring-shaped meshes while keeping the same polygon construction logic.

### Antialiasing ring

When `jaggedFree = true`, the mesh adds a thin outer fade ring. Conceptually, it creates one ring close to the edge:

$$
p_{\text{fade}} = \frac{r - \delta}{r}
$$

and another one at the final boundary:

$$
p_{\text{outer}} = 1
$$

Then the outer alpha fades toward zero:

$$
\alpha_{\text{outer}} = 0
$$

This soft transparent ring helps reduce jagged polygon edges.

### Texture coordinates

When a texture is attached, the mesh also generates texture coordinates. For a rectangular mesh, texture coordinates follow the same normalized grid idea:

$$
U_{ij} = d_x u_i + a_x(t_w - d_x)
$$

$$
V_{ij} = d_y v_j + a_y(t_h - d_y)
$$

Where:

* (t_w), (t_h) are the texture width and height;
* (d_x), (d_y) are the visible texture dimensions after scaling;
* (a_x), (a_y) are the texture anchor values.

For polygon meshes, the texture coordinates follow the same radial idea as the geometric vertices, which is what allows image textures to be clipped, rotated, and tinted by polygon geometry.


---

## Installation

Copy `src/gradient_mesh.lua` into your Gideros project and require it from your scene or example file:

```lua
local GradientMesh = require "src/gradient_mesh"
```

---

## Quick start

```lua
local GradientMesh = require "src/gradient_mesh"

local gradient = GradientMesh.new()

gradient:rectangle({
    color = {
        0x0f2027,
        0x203a43,
        0x2c5364
    },
    alpha = {1, 1, 1},
    dimension = {320, 180},
    anchor = {0.5, 0.5},
    position = {160, 240},
    way = "lr"
})

stage:addChild(gradient)
```

---

## Radial example

```lua
local GradientMesh = require "src/gradient_mesh"

local glow = GradientMesh.new()

glow:circle({
    radius = 180,
    edges = 96,
    color = {
        0x833ab4,
        0xfd1d1d,
        0xfcb045
    },
    position = {240, 240},
    way = "co",
    jaggedFree = true
})

stage:addChild(glow)
```

---

## Regular polygon example

```lua
local GradientMesh = require "src/gradient_mesh"

local polygon = GradientMesh.new()

polygon:regularPolygon({
    edges = 6,
    radius = 160,
    color = {
        0x4776e6,
        0x8e54e9
    },
    position = {240, 240},
    scalePolygon = {1, 1},
    rotationMesh = 0,
    jaggedFree = true
})

stage:addChild(polygon)
```

---

## Configuration reference

| Option         | Description                                                     |
| -------------- | --------------------------------------------------------------- |
| `color`        | List of colors assigned to gradient stops.                      |
| `alpha`        | Optional alpha values per color stop.                           |
| `dimension`    | Width and height for rectangular gradients.                     |
| `radius`       | Radius for circles and regular polygons.                        |
| `edges`        | Number of polygon edges. Higher values create smoother circles. |
| `position`     | Mesh position on stage.                                         |
| `anchor`       | Anchor point for rectangular gradients.                         |
| `way`          | Gradient direction: `tb`, `bt`, `lr`, `rl`, `co`, `oc`.         |
| `hole`         | Enables an inner hole for radial shapes.                        |
| `rIn`          | Inner radius when `hole` is enabled.                            |
| `scalePolygon` | Deforms polygon/circle proportions.                             |
| `rotation`     | Rotates the full mesh object.                                   |
| `rotationMesh` | Rotates only the mesh vertices.                                 |
| `texture`      | Optional texture configuration.                                 |
| `jaggedFree`   | Adds a soft transparent ring to reduce jagged edges.            |
| `colorOn`      | Enables or disables mesh color assignment.                      |

---

## Project structure

```txt
Gradient/
├── docs/images/          # Rendered examples and visual outputs
├── Samples/          # Gideros sample scenes
├── Sources/          # Images, fonts, and source assets
├── main.lua          # Sample selector
├── GradientMesh.lua    # Core gradient mesh utility
├── Gradient.gproj    # Gideros project file
├── LICENSE
└── README.md
```

---

## Suggested visual cleanup

To make the repository feel more modern and portfolio-ready:

1. Keep generated images clean, without text overlays.
2. Use descriptive file names.
3. Present gradient names in the README, not inside the image.
4. Prefer polished abstract visuals over model/face examples unless the source images are licensed, high quality, and visually consistent.
5. Add one hero image at the top once the visual identity is stable.

Recommended result names:

```txt
gradient-mesh-regular-polygons.png
gradient-mesh-cosmic-fusion.png
gradient-mesh-firewatch.png
gradient-mesh-mango.png
gradient-mesh-royal-blue.png
gradient-mesh-big-rainbow.png
gradient-mesh-big-fog.png
```

---

## Built with

* [Lua](https://www.lua.org/)
* [Gideros](https://github.com/gideros/gideros)

---

## Inspiration

This project was inspired by gradient palette collections such as [GradientMeshs](https://GradientMeshs.com/), but implemented as procedural mesh rendering for Gideros.

---

## Authors

* **Hubert Ronald** - *Initial work* - [HubertRonald](https://github.com/HubertRonald)

See also the list of [contributors](https://github.com/HubertRonald/Gradient/contributors) who participated in this project.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
