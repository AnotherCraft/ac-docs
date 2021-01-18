# `ChunkAnchorManager`
ChunkAnchorManager is a class that handles determining which chunks should be kept loaded and which not. That is realized by creating anchors (a separate object type - there can be multiple anchor types depending on the shape).

Anchor is an object that keeps chunks around it anchored (loaded in the memory if the anchor manager is used as an activity director, but there are other uses for chunk anchoring - for example client has a second anchor manager that determines which chunks should be rendered).

`ChunkAnchorManager` simple keeps tracks of what chunks are anchored and what not and reports it on request.

## Implementation notes
Following implementation is recommended:
* Anchor manager keeps list of chunks that are not loaded yet but should be loaded, because they are anchored.
  * When world requests it (presumably in its step function), the anchor manager returns the list to the world and clears it internally, world then handles the chunk loading.
* In the same manner, the list of chunks that are loaded but should be unloaded is kept and passed to the world on function call.

* The anchor manager keeps a hash map where key is `ChunkWorldPos` and value is number of anchors that keep a given chunk loaded. Individual anchors are reponsible for increasing/decreasing this number as they are created/moved/destroyed. When the number hits zero, the record is removed from the hash map and the chunk is marked for unloading.