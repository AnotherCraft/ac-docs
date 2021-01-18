# `BlockWorldPos`
`BlockWorldPos` is a three-dimensional vector class used for representing position of a block in a world.

Components are of type `BlockWorldPos_T`, which is `int32`.

## Properties
### `chunkPosition: ChunkWorldPosition`
Coordinates of the chunk the block is in.

### `x, y, z: BlockWorldPos_T`
Components of the vector

## Methods
The object supports standard vector operations: addition, subtraction, multiplication, division (per-component, also `vec op constant` variants).