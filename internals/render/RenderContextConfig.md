# `RenderContextConfig`
The `RenderContextConfig` stores configuration of how textures should be rendered in the world.

# Defining in YAML
In YAML, the definition is done as a key-value map with corresponding properties. The only change is that enum values are not capitalized. The

```YAML
animation: windOnlyTop
faceCulling: false
alphaTestThreshold: 0.5
```

# Properties
### `animation : Animation = None`
Blocks can be animated in various vays (implemented in vertex shader).

#### `Animation`
* `None`: No animation
* `WindOnlyTop`: Top of the side is waving in the wind (grass)
* `WindWholeBlock`: The whole block is waving in the wind (leaves)
* `LiquidSurface`: Used for top faces of liquid blocks
* `LiquidSides`: Used for side faces of liquid blocks

## Texturing
### `mipMapping : Bool = true`
Determines if mip mapping is enabled.

### `smoothTexturing : Bool = true`
Enables special texture filtering that prevents aliasing/sharp pixel edges when looking on low definition block textures from up close.

### `textureRepeatX, textureRepeatY: Bool = true`
Texture repeating. Disabling it can reduce certain rendering artefacts, however disable it only when the texture will really never be repeated (for example because of block face aggregation).

### `faceCulling: Bool = true`
When set to `true`, only front sides of the face are rendered (the face is not visible when looking from behind). Increases performance. Makes sense to be turned on for most of the blocks. For stuff like grass etc, it should be turned off (block shape components like `BTC_CrossShape`, `BTC_HashShape` etc. do it automatically).

### `doNotInvertNormalZ : Bool = false`
If `true` and when `faceCulling` is disabled, the `z` component of the normal is not inverted when looking on a face from behind.

## Transparency
### `alphaChannel : AlphaChannel = Unused`
Determines how alpha channel is handled

#### `AlphaChannel`
* `Unused`: Alpha value is ignored. Very fast rendering.
* `AlphaTest`: Alpha testing - pixels with alpha lower than `alphaTestThreshold` are discarded (completely transparent), the rest is fully opaque (faster than full transparency).
  * Mipmapping is still enabled with AlphaTest. Because of that, we recommend setting transparent pixels of alpha tested textures not to full transparent, but to semi-transparent color relevant to the image. This is because at greater distances (smaller mipmap levels), the transparent and non-transparent pixel colors will be blended together.
* `Transparency`: Alpha value determines transparency. The most performance-demanding option.

### `alphaTestTreshold : Float = 0.9`
When `alphaChannel = AlphaTest`, this value determines the alpha threshold under which the fragments are discarded. 

### `alphaTestDisableInShadowMap : Bool = false`
Alpha testing can be disabled in shadow maps for increasing performance.

## Distance cutoff
There can be a distance cutoff defined. Faces rendered behind the cutoff distance can have different rendering config.

The cutoff is sharp and calculated on per-chunk level.

### `distanceCutoff : Float = 128`
The cutoff distance.

### `alphaTestDistanceCutoff : Bool = false`
If set to `true`, alpha test will be disabled after the cutoff distance. This can increase performance significantly.

### `renderingDistanceCutoff : Bool = false`
If set to `true`, rendering is not realized at all behind the cutoff distance.