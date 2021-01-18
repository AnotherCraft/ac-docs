# `BlockIDMappingManager`
The `BlockIDMappingManager` manages mapping block IDs (`UInt16`) to actual `BlockType` objects.

Block ID mapping can differ in each game. New block types can be introduced mid-game (for example when adding a new mod), adding more IDs to the list.

Once a block UID gets the ID assigned, it can never change in the game.

## Methods
### `getBlockID(uid: BlockUID): BlockID`
Returns block ID for the given block UID or `0` if the block UID is not registered.

### `getBlockUID(id: BlockID): BlockUID`
Returns block UID of the block type associated with the provided `id` (or empty UID if the block ID does not exist).

### `getBlockType(id: BlockID): BlockType`
Returns block type of the given ID (or `null`).