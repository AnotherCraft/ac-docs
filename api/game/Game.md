# `Game`

The `Game` object represents a whole game (running on a single server), encapsulating possibly multiple worlds.

## Properties
### `blockTypeManager: BlockTypeManager`
Manager that stores what block types are registered within the game.


### `blockIDMapping: BlockIDMappingManager`
Manager that handles associating numeric IDs for registered block types.

## Methods
### `maybeWorld(id: WorldID): World`
Returns world with given ID if it is loaded in the memory, otherwise returns `null`.