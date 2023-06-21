# `ChunkAnchor_Rectangle`
This object keeps a given rectangular area of chunks anchored (preventing them from unloading/other anchoring purpose depending on what `ChunkAnchorManager` the anchor is linked to). While it exists, the are is anchored.

## Properties
### `manager: ChunkAnchorManager`
Manager the anchor is assigned to.

### `center: ChunkWorldPos`
Center of the anchor rectangle.

### `radius: ChunkWorldPos_T`
Radius of the anchor. The anchor shape is rectangle, so the anchored are is from `(center.x - radius, center.y - radius)` to `(center.x + radius, center.y + radius)` inclusive.

The radius is inclusive, meaning `radius=0` anchors only the `center` chunk, `radius=1` the center chunk and its neighbours etc.

## Methods
### `setManager(manager: ChunkAnchorManager)`
Assigns the anchor to the given manager.

### `set(center: ChunkWorldPos, radius: ChunkWorldPos_T)`
Sets the anchor rectangle to be at centered at `center` with a given `radius`.

### `setRadius(radius: ChunkWorldPos_T)`
Changes the radius of the anchor (while keeping the center). Equivalent to `set(oldCenter, radius)`.

### `moveCenter(center: ChunkWorldPos)`
Moves the center of the anchor (while keeping the radius). Equivalent to `set(center, oldRadius)`.

## Implementation notes
The recommended implemetnation is that the anchor is increasing/decreasing a counter for each chunk as it is moved around/configured. The counter determines how many anchors are keeping a given chunk anchored. When the counter drops to 0, the chunk is marked for unloading.