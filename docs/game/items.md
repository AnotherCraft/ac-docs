# Items

I think it's not necessary to explain what items are.

* Each item is represented by a `ItemInstance` class instance. There is no aggregation for stacks of items.
* Each item has a persistent handle that uniquely identifies it within a game.
* While items can be in void (not assigned to any inventory), they're usually worked with while inside an inventory.
* Items are transferred between inventories using inventory transactions (standard, slot swap or crafting) - more on that elsewhere.
* When items are placed in the world (thrown from the inventory, dropped from blocks, ...), it's not really the item you see, it's the `entity.item` entity that holds the items inside and renders them through `IA_WorldRender` 
* Items can be equipped onto entities. In that case, they're rendered through `IA_EquippedRender`
* Items also have icon that is used in the GUI - that one uses `IA_Icon`.