# `ComponentBlockType`
`ComponentBlockType` is a subclass of `BlockType` that implements component approach to defining block types.

The idea is that instead of implementing every method of the block manually, the block type is put together with various components that give the block its properties - how it looks (shape), if it's opaque, if it emits light, collisions, dynamic behaviour etc.

## Methods
This class basically overrides all `BlockType` block functions, passing the calls to the respective components.

The `BlockTypeComponent` (the component base class) then declares all block functions and individual component implementations can implement them.

# Defining in YAML
In the YAML mod definition files, components are added to a block by defining them in the `blocks/(block)/components` sequence, for example:

```YAML
blocks:
	# block sequence here
	
  - block: block.core.dirt
    components:
      - component: StaticOpacity
    
      - component: UniformBlockShape
				texture: block/dirt.png
```

Component names correspond with the API class names, just without the `BTC_` prefix.
Properties are specified as key-value map within the component definition.

### `addComponent(component: BlockTypeComponent)`
Adds component to the block type. This function can only be called in the initialization phase of the game.

# Component types

## Shape components
Shape components determine look/shape of the block. Unless explicitly specified, the shape is static.

### `BTC_BlockShapeBase`
Base class for block shapes (standard grid aligned cubes).

* `selfOpaque: bool`
  * Self opaque blocks do not rener faces adjacent to a block of the same type. This is used for example with glass or any semi-transparent stuff.

### `BTC_UniformBlockShape : BTC_BlockShapeBase`
Standard block with all sides having the same texture.

* `texture: RenderContextTexture`

### `BTC_UniformSidesBlockShape : BTC_BlockSHapeBase`
Standard block, sides have the same texture, top and bottom have different textures.

* `sidesTexture: RenderContextTexture`
* `topTexture: RenderContextTexture`
* `bottomTexture: RenderContextTexture`

### `BTC_CrossShape`
Cross shape (+).

* `texture: RenderContextTexture`

### `BTC_DiagonalCrossShapeShape`
Diagonal cross shape (X).

* `texture: RenderContextTexture`

### `BTC_HashShape`
Hash shape (#).

* `texture: RenderContextTexture`

## Light-related components

### `BTC_StaticOpacity`
Adds static opacity to the block (the block blocks light going through). Unless the `opacity` is specified, the block blocks all light going through.

* `opacity: BlockLightLevel`

### `BTC_StaticLightEmitter`
Block emits constant amount of light.

* `emission: BlockLightLevel`