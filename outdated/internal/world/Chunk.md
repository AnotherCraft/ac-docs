# `Chunk`
Chunk represents a chunk of a world with 16x16x256 blocks (XY - horizontal, Z - vertical). Chunks do not stack vertically - there is always only one chunk at given X,Y coordinates. Each chunk can however have different zOffset - meaning it can be at a different height.

## Properties
### `world: World`
World the chunks belongs to.

### `pos: ChunkWorldPos`
Position of the chunk in the world, in chunk coordinates.

### `offset: BlockWorldPos`
Position of the chunk in the world, in block coordinates (also includes zOffset).

### `zOffset: BlockWorldPos_T`
Z offset of the chunk – Z position of the bottom of the chunk. Deterined by the worldgen, is always a multiple of 16.

## Methods
### `eventSubscribedBlocks(event: WorldEvent) : List<ChunkBlockIndex>`
Returns list of blocks that are subscribed to `event`.

## Implementation notes
* The chunk can be further separated vertically into sub chunks (recommended size 16x16x16). Sub chunks that contain only air do not have to be stored in the memory, saving resources.
* It is recommended to keep the block ID array and block small data array separate (so `BlockID blockIDs[65536]; BlockSmallData blockSmallData[65536];`), because it should be faster.