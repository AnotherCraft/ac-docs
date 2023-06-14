# Inventories

* Inventory is an object that holds stacks of items (`ItemStack` class). It has a defined number of slots, each slot can hold up to `ItemTypeStaticProperties::maxStackSize` items of the same type.
* Inventories are not typed (there is no `InventoryType` class) – each inventory is to be set up independently.
* Inventories can have components that specify the behaviour of the inventory
  * Access components like:
    * `INC_ActorAccess` grants access to the inventory to the specified actor
    * `INC_ViewOnlyAccess` makes the inventory view only (no withdraws/deposits allowed, only for the root actor)
    * `INC_WithdrawOnlyAccess` makes the inventory withdraw only (used for loot inventories)
  * Content restriction components like:
    * `INC_RestricContentByTag` only allows items with certain tag to be placed in the inventory
      * Used for player top-level inventory that is only for bags
  * Nesting/ownership components like:
    * `INC_Entity(Equipment|Public|Private)Inventory`
    * `INC_BlockInventory` allows access to actors near the block
    * `INC_BagInventory|INC_ItemNestedInventory`
* By default, inventory does not allow access (view/move items) to anyone (except for the root/system actor) – permissions ought to be added through the components.

## Multiplayer synchronization

* Inventories are usually initially sent to the client together with a block, entity or whatever – this is how the client usually gets to know about the inventory and its initial state (`ACP::Inventory`).
* Updates within inventory are handled through client subscriptions – the client is subscribed to a chunk the inventory is affiliated with.
* However the client can also request inventory serialization using the `ACP::InventoryRequest` and `ACP::InventorySlotRequest` messages.
  * The whole `ACP::InventoryRequested` is performed for example when a client discovers that the inventory is smaller than it should be (receives transaction pointing to a larger slot ID than the local inventory size).
  * Partial `ACP::InventorySlotRequest` is issued when:
    * There's an inventory slot desynchronization detected: Server reports something that shouldn't be possible with the slot based on client's knowledge.
    * When there's a transaction report of unknown items – when the client receives report that items should be moved to a slot, but the client doesn't have the items in the memory (possibly because they were either in void or in an inventory not accessible to the client). In that case, the transaction fails, but `ACP::InventorySlotRequest` is issued that should eventually update the target transaction slot with the correct items.