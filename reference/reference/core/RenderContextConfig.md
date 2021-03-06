# `RenderContextConfig`

> **Children:**<br>
> [RenderContextTexture](RenderContextTexture.md)

> **Used in:**<br>
> [RenderContextTexture](RenderContextTexture.md)

> **See also:**<br>
> [RenderContextTexture](RenderContextTexture.md)

## Properties
### `alphaChannel`
> **Default value:** `unused`<br>

How the alpha channel is used.

Accepted values are:
* `unused`: The alpha channel is not used.
* `alphaTest`: The alpha channel is used for alpha testing - if the pixel alpha is below `alphaTestThreshold`, the pixel is not rendered at all, otherwise it is rendered at full opacity. Alpha testing is much faster than proper transparency, so it is recommended to design blocks for alpha testing instead of transparency.
* `alphaTestConfigurable`: Same as alpha test, but the alpha testing can be disabled in settings (`settings_graphics_alphaTesting`) - can be used for example for tree leaves.
* `transparency`: The alpha channel is used for proper transparency. Rendering transparent textures is quite demanding and it is recommended to rather use alpha testing. Transparent blocks do not cast shadows.

### `alphaTestDisableInCoarseShadowMap`
> **Type:** bool<br>
> **Default value:** `true`<br>

If `true`, the alpha testing is not enable in coarse shadow maps - the detail is lost on shadows further from the player.
### `alphaTestDisableInShadowMap`
> **Type:** bool<br>
> **Default value:** `false`<br>

If `true`, the alpha testing is not enabled in shadow maps at all, making the texture to cast shadow regardless of whether the pixels are transparent or not. Saves performance.
### `alphaTestDistanceCutoff`
> **Type:** bool<br>
> **Default value:** `false`<br>

Disables alpha testing for the texture if it is more than `cutoffDistance` blocks from the camera.
### `alphaTestThreshold`
> **Type:** float<br>
> **Default value:** `0.9`<br>

Threshold for alpha testing
### `animation`
> **Type:** [Identifier](Identifier.md)<br>

Animation of the texture (implemented in the vertex shader).

For example: `windOnlyTop`, `windWholeBlock`

### `customAlphaPremultiplication`
> **Type:** bool<br>
> **Default value:** `false`<br>

Indicates that the texture is alpha premultiplied (RGB is multiplied by A).
### `cutoffDistance`
> **Type:** float<br>
> **Default value:** `128`<br>

Distance at which the cutoff is realized (what the cutoff actually does is defined through other properties)
### `disableCoarseShadows`
> **Type:** bool<br>
> **Default value:** `false`<br>

Makes the texture not cast any shadow on coarse shadow maps (further from the player). Saves performance. Recommended for small stuff like grass.
### `disableShadows`
> **Type:** bool<br>
> **Default value:** `false`<br>

Makes the texture not cast any shadow. Saves performance.
### `doNotInvertNormalZ`
> **Type:** bool<br>
> **Default value:** `false`<br>

If `true`, does not invert the `z` component of the normal when looking on the block from behind.
### `doNotRenderWhenAlphaTestingDisabled`
> **Type:** bool<br>
> **Default value:** `false`<br>

Disables rendering of the texture altogether if configurable alpha testing is disabled (`settings_graphics_alphaTesting`).
### `faceCulling`
> **Type:** bool<br>
> **Default value:** `true`<br>

Whether face culling is enabled. Makes the texture not rendered when looking from behind, saves performance. Is usually turned off automatically for block shapes where appropriate.
### `mipMapping`
> **Type:** bool<br>
> **Default value:** `true`<br>

### `naturalTexturing`
> **Type:** bool<br>
> **Default value:** `false`<br>

Experimental, ignore
### `renderingDistanceCutoff`
> **Type:** bool<br>
> **Default value:** `false`<br>

Disables rendering of the texture altogether if it is more than `cutoffDistance` blocks from the camera.
### `shaderEffect`
> **Type:** [Identifier](Identifier.md)<br>

Shader effect (implemented in fragment shader).

For example: `hologram`

### `smoothTexturing`
> **Type:** bool<br>
> **Default value:** `true`<br>

Alternative to ugly `GL_NEAREST` filtering when looking on pixelart textures from up-close.
### `textureRepeatX`
> **Type:** bool<br>
> **Default value:** `true`<br>

Indicate that the texture should repeat along the X axis (stuff might not work properly as a lot of block shapes rely on greedy meshing, use with caution in blocks).
### `textureRepeatY`
> **Type:** bool<br>
> **Default value:** `true`<br>

Indicate that the texture should repeat along the Y axis (stuff might not work properly as a lot of block shapes rely on greedy meshing, use with caution in blocks).
