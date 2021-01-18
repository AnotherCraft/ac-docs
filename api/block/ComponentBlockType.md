# `ComponentBlockType`
`ComponentBlockType` is a subclass of `BlockType` that implements component approach to defining block types.

The idea is that instead of implementing every method of the block manually, the block type is put together with various components that give the block its properties - how it looks (shape), if it's opaque, if it emits light, collisions, dynamic behaviour etc.

## Methods
This class basically overrides all `BlockType` block functions, passing the calls to the respective components.

The `BlockTypeComponent` (the component base class) then declares all block functions and individual component implementations can implement them.

### `addComponent(component: BlockTypeComponent)`
Adds component to the block type. This function can only be called in the initialization phase of the game.

# Component types

## Shape components
Shape components determine look/shape of the block. Unless explicitly specified, the shape is static.

### `BTC_UniformBlockShape(tex: Texture)`
Standard block with all sides having the same texture.

### `BTC_UniformSidesBlockShape(texSides, texTop, texBottom: Texture)`
Standard block, sides have the same texture, top and bottom have different textures.

### `BTC_CrossShape(tex: Texture)`
Cross shape (+).

### `BTC_DiagonalCrossShapeShape(tex: Texture)`
Diagonal cross shape (X).

### `BTC_HashShape(tex: Texture)`
Hash shape (#).

## Light-related components

### `BTC_StaticOpacity(opacity: BlockLightLevel = maxLightLevel)`
Adds static opacity to the block (the block blocks light going through). Unless the `opacity` is specified, the block blocks all light going through.

### `BTC_StaticLightEmitter(emitLevel: BlockLightLevel)`
Block emits constant amount of light.