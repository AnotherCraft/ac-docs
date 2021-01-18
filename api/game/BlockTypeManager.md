# `BlockTypeManager`
Block type manager is a simple list containing all registered blocks in the game.

## Properties
### `registeredTypes: List<BlockType>`
List of registered types in unspecified order.

## Methods
### `getBlockTypeByUID(uid: BlockUID): BlockType`
Returns block type with a given `uid` or `null` if no block with such UID is registered.