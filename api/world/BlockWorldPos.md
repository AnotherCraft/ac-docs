# `BlockWorldPos`
`BlockWorldPos` is a three-dimensional vector class used for representing position of a block in a world.

Components are of type `BlockWorldPos_T`, which is `Int32`.

## Properties
### `chunkPosition: ChunkWorldPosition`
Coordinates of the chunk the block is in.

### `x, y, z: BlockWorldPos_T`
Components of the vector

## Methods
The object supports standard vector operations: addition, subtraction, multiplication, division (per-component, also `vec op constant` variants).

### `chunkBlockIndex(chunkZOffset: BlockWorldPos_T): ChunkBlockIndex`
The `ChunkBlockIndex` is a 2-byte unsigned integer representing position of the block in the chunk/index of the block in the internal chunk array (`ix = x + y * 16 + z * 256`).