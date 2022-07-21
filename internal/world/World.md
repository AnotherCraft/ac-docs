# `World`
The `World` object represents a single world.

World consists of `Chunks` that contain 16x16x256 blocks (x, y coordinates are for horizontal position, z is for vertical position). Chunks are arranged in a sparse 2D grid – the world can be potentially infinite and not all the chunks are requried to be loaded at the same time.

For determining what chunks should be loaded, the `chunkActivityDirector` of type `ChunkAnchorManager` is utilized.

## Properties
### `world: World (thread-local)`
Thread-local variable storing pointer to the current world.

### `game: Game`
Game the world belongs to.

### `worldID: WorldID`
ID of the world withing the game (`UInt16`).

### `chunkActivityDirector: ChunkAnchorManager`
Manager that handles determining which chunks should be active/loaded and which not.

## Methods
### `maybeChunk(pos: ChunkWorldPos): Chunk`
Returns chunk at position `pos` if it is currently loaded in the memory. Returns `null` otherwise.

### `eventSubscribedChunks(event: WorldEvent) : List<Chunk>`
Returns list of chunks that are subscribed to `event`.

## Implementation notes
* It is recommended to store chunks as a hash table with the position of the chunk (2D - `ChunkWorldPos`) as the key.