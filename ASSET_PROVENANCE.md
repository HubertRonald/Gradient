# Asset provenance

This document records the current publication boundary for bundled assets in **GradientMesh**.

GradientMesh is a historical Lua/Gideros creative-coding project originally implemented in the 2017–2018 period and refreshed in 2026 for portfolio documentation. The MIT license in this repository applies to the source code unless otherwise stated. Bundled third-party or historical visual assets should not be assumed to be MIT-licensed.

## Source code

The core Lua implementation is preserved as a historical Gideros mesh-gradient experiment by Hubert Ronald.

The implementation references uiGradients as visual/palette inspiration. The project may load gradient color data from the public uiGradients `gradients.json` endpoint in the `gradient_overlay` example. uiGradients is a third-party project and is not bundled in this repository.

## Font asset

| Path | Origin | License / status | Decision |
| --- | --- | --- | --- |
| `assets/fonts/Roboto-Regular.ttf` | Roboto font family | Roboto is distributed by Google/Android under the Apache License 2.0. | Retained as a third-party licensed font asset. |

## Historical visual assets with limited provenance

The following visual assets are retained because they are used by the preserved historical examples or by 2026 screenshots that document those examples.

Their exact upstream source and original license could not be fully reconstructed from the repository history. They are retained only as historical, non-commercial demonstration assets for this preserved creative-coding project.

They should not be treated as part of the MIT-licensed source code. Downstream users should replace them with their own licensed assets before redistribution, publication in another product, or commercial use.

| Path / group | Current use | Provenance status | Decision |
| --- | --- | --- | --- |
| `assets/images/landscapes/pexels-photo-89432.png` | Texture input for `examples/gradient_overlay.lua` | Historical external/demo image; exact license not reconstructed. | Retained with limitation. |
| `assets/images/legacy-faces/ariel-lustre-208615.png` | Texture input for `examples/texture_mask_rotated_mesh.lua` | Historical external/demo image; exact license not reconstructed. | Retained with limitation. |
| `assets/images/legacy-faces/peruvianModel_Maju_001.png` | Texture input for `examples/hexagon_portrait_texture_mask.lua` | Historical external/demo image; exact license not reconstructed. | Retained with limitation. |
| `assets/images/splashes/splashWhite_001.png`, `splashWhite_003.png`, `splashWhite_005.png`, `splashWhite_007.png`, `splashWhite_008.png`, `splashWhite_009.png` | Texture-mask inputs for `examples/radial_gradient_splash_masks.lua` | Historical splash-mask assets; exact upstream source not reconstructed. | Retained with limitation. |

## Generated documentation images

The images under `docs/images/` are rendered documentation outputs. Some are historical outputs moved from the original `Results/` directory, while others were regenerated during the 2026 documentation refresh.

Generated documentation images that derive from historical visual assets inherit the same provenance limitation as their source textures.

## Removed assets during 2026 remediation

The following files were removed from the current tree because they were not used outside the Gideros project file or were unreferenced documentation leftovers:

- `assets/images/landscapes/jeremiah-berman-282409.png`
- `assets/images/splashes/splashWhite.psd`
- `assets/images/splashes/splashWhite_002.png`
- `assets/images/splashes/splashWhite_004.png`
- `assets/images/splashes/splashWhite_006.png`
- `docs/images/gradient-mesh-cosmic-fusion.png`
- `docs/images/gradient-mesh-regular-polygons.png`

## Personal data remediation

A historical personal contact line was removed from the current published source tree during the 2026 remediation. Repository history was preserved.
