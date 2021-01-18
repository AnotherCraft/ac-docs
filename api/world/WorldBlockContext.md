# `WorldBlockContext`
The `WorldBlockContext` class is used to represent and manipulate individual blocks in the world. It provides methods for acessing, reading and writing the blocks. This is the only way the blocks should be acessed.

## Properties
### `isValid: Bool`
Returns whether the context is bound to a valid block in the world (existing and loaded in the memory).

### `world: World`
World the context is currently bound to.

Returns `null` if the context is not valid.

### `chunk: Chunk`
Chunk the context is currently bound to.

Returns `null` if the context is not valid.

### `pos: BlockWorldPos`
Position of the block the context is currently bound to.

If the context is not valid, the value is unspecified.

### `blockType: BlockType`
Type of the block the context is currently bound to.

The behaviour is undefined is this property is accessed in an invalid context.

### `blockID: BlockID`
ID of the block type the context is currently bound to.

The behaviour is undefined is this property is accessed in an invalid context.

### `isAir: Bool`
Returns whether the block the context is currently bound to is air (ID = 0).

The behaviour is undefined is this property is accessed in an invalid context.

## Methods
### `unbind()`
Unbinds the context, making it invalid.

### `bind(world: World, pos: BlockWorldPos): BindResult`
Attempts to bind the context to block at position `pos` in world `world`. Returns if the binding was sucessful or not (that is also reflected in the `isValid` property).

`BindResult` (enum):
* `Success`: the binding was successful
* `VerticallyOutsideChunk`: the block requested is vertically outside chunk (above or below the chunk vertical limits)
* `ChunkNotLoaded`: the chunk the block belongs to is not loaded in the memory.

### `bind(chunk: Chunk, ix: ChunkBlockIndex)`
Binds to block `ix` in chunk `chunk`.

The `ChunkBlockIndex` is a 2-byte unsigned integer representing position of the block in the chunk/index of the block in the internal chunk array (`ix = x + y * 16 + z * 256`).

### `setBlockID(id: BlockID)`
Sets ID of the block the context is currently bound to to `id`.

This is usually not enough for constructing a block in the world - the original block has to be properly deconstructed (destruction events called), the new block has to be properly constructed (data set, construction events called).

The behaviour is undefined is this method is called in an invalid context.

### `subscribeToEvent(event: WorldEvent)`
Subscribes the block to `event`.

The behaviour is undefined is this method is called in an invalid context.

### `unsubscribeFromEvent(event: WorldEvent)`
Unsubscribes the block from `event`.

The behaviour is undefined is this method is called in an invalid context.