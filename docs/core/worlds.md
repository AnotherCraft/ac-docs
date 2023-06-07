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

