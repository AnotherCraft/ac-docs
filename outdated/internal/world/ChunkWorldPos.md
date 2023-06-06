# `ChunkWorldPos`
`ChunkWorldPos` is a two-dimensional vector class used for representing position of a chunk in the world. Components are of type `BlockWorldPos_T`, which is `Int32`.

Chunks arranged in a sparse 2D grid, chunks do not stack vertically. Chunks can have different z offsets, but the `ChunkWorldPos` class does not consider that information.

In difference to the `BlockWorldPos` vector, which has one block as a unit, the `ChunkWorldPos` has a chunk as a unit, so 16x16 blocks. So `BlockWorldPos` and `ChunkWorldPos` do not have the same base units. 

## Properties
### `x, y, z: ChunkWorldPos_T`
Components of the vector

## Methods
The object supports standard vector operations: addition, subtraction, multiplication, division (per-component, also `vec op constant` variants).