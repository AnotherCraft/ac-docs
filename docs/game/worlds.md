# Worlds

The game has the following structure:

* `Game ` encompasses everything in a single game.
* The game can have multiple `World`s. Worlds are independent on each other, entities can be potentially teleported between them.
* Worlds are split horizontally into `Chunk`s. Chunks are stored in a hash table and accessed with the `ChunkWorldPos` key.
  * Chunks store a list of `EntityInstance`s within them (`ChunkEntityManager`).
* Each chunk contains 16×16 blocks horizontally and 256 blocks vertically.
  * Each chunk can have a different `zOffset` (it can start in a different height). This allows for potentially high elevation differences in the world. `zOffset` is always a multiple of `16`.
  * Chunks are internally sub-split into 16 sub chunks of  16×16×16 blocks. If all blocks inside subchunk are air, the sub chunk isn't allocated to optimize memory usage.
* Each block stores the following data:
  * `BlockID` (2 bytes unsigned) – identifies the block type, stored as flat static array inside subchunk.
    * Block IDs are also copied to the GPU and stored in a sparse 3D texture (in 16×16×16 sub chunks).
      * Block IDs on the GPU are used for lighting calculations, mesh rendering optimizations, volumetric fog, particle collisions and others.
      * Other block data is not stored on the GPU.
  * `BlockSmallData` (1 byte) – for some supplementary data, always present with the block, stored as flat static array inside subchunk.
  * If the block needs to store more data than 1 byte (or if there are multiple components that want to use the small data), `BlockBigData` is created. This data is created dynamically and is accessed through hash table `ChunkBlockIndex -> BlockBigData` stored within the `Chunk` class.
  * Block mining progress is stored in a similar manner, as a hash table `ChunkBlockIndex -> BlockMiningProgress` inside `Chunk`.
* Additionally, for client, chunks are also split into a few different subchunk structures for rendering:
  * 8 `GPURenderSubChunk` sub chunks of`16×16×32`. These store rendering meshes for their respective areas and are a base unit of rendering and frustum culling, occlusion culling and so on.
  * 16×16×16 light map sub chunks storing light information (R, G, B, D) where D is daylight – total of 2 bytes per block.

## Chunk anchors

The world is potentially infinite and computer memory is finite, so there must be some mechanisms to determine which chunks should be kept in the memory and which can be unloaded – that's what chunk anchors are for.

* Chunk anchors "anchor" the chunks around them and keep them loaded (and request them if they're not loaded).

* Chunk anchors can be moved and resized.
* Typically, chunk anchors are tied to players, but there can be other anchors as well.
  * For example, one could create an admin "anchor" block that would be placed in a center of a city to keep the city loaded even when there's no player in it.
  * Or there could be user-craftable chunk anchors that would require energy to work.
  * On clients, the only chunk anchor should be the local player.
* Anchors are represented by the `ChunkAnchor_Rectangle` class with center and radius properties.
  * `ChunkAnchorManager` class then manages which chunks are anchored and which are not. The class is instanced as `chunkActivityDirector` inside the `World` class.
  * Additionally, there's a separate anchoring manager for having stuff kept in the GPU memory (and rendered – meshes, light maps, block ID maps, ...) - `Chunk_ClientComponent::chunkVisibilityDirector`.
    * This director has a separate anchor set, typically consisted of a single anchor tied to the local player. This anchor has a radius one chunk smaller than the activity anchor – so that neighbouring chunks of the rendered chunks are also kept in the memory. This is necessary for various calculations like mesh optimization and light propagation.

## Requesting chunks by the clients

* Client itself determines which chunks it should have in its local memory and which to request from the server. It keeps its own `chunkActivityDirector` that handles that (typically it only contains a single anchor - the local player).
* When client wants a chunk, it sends `ACP::ChunkRequest` message to the server. When it stops wanting a chunk, it sends `ACP::ChunkUnrequest`.
  * Requesting/unrequesting the same chunk multiple times is not allowed.
* The server then sends `ACP::Chunk` chunk data.
  * The server does not have to respond with `ACP::Chunk` right away – the request is asynchronous. It can for example take some time for the chunk to be loaded and ready, serializing chunks also takes some processing time so the server can spread it over some period of time.
  * From the moment the server sends the `ACP::Chunk`to the client, the client is also subscribed to the chunk and any further updates inside the chunk (until `ACP::ChunkUnrequest` is processed) – such as block builds/destroys/updates, entity movement and so on.
  * There is currently no mechanism to check whether the chunk request is legit or not - the client can request chunks on the other end of the world and the server would send it to them if they're anchored, this should be fixed in the future.
* Further updates of the chunk blocks and entity movements are handled by individual update messages such as `ACP::BlockInit`, `ACP::ETCPhysicsMUpdate` and so on.
