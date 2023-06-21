# Inventory transactions

Inventory transactions are the only (aside from crafting transactions) method of moving items between inventories (and void).

* There are two (and half) types of inventory transaction:
  * Standard inventory transaction: moves a specified `ItemStack` into a specified `Inventory` on a specified target slot.
    * Items in the `ItemStack` are always of the same type. but do not necessarily have to be from the same inventory/slot. Neither does the item stack have to originate from the same inventory as the target slot.
    * The target slot doesn't have to be empty, but it has to be able to accommodate the source stack (`ItemTypeStaticProperties::maxStackSize`).
    * While the source item stack can be larger than `ItemTypeStaticProperties::maxStackSize`, in practice such transaction would always fail because the stack wouldn't fit to the target slot (except for possibly inventories/slots that allow larger stack sizes, but those are not implemented yet).
  * Slot swap transaction: swaps contents of two specific inventory slots (doesn't have to be of the same inventory)
    * For slot swap transactions, the transaction checks are done with the `InventoryTransactionFlag::assumeTargetSlotEmpty`, because we could be simultaneously swapping two nonempty slots, in which case a whole bunch of checks would fail.
  * Auto transaction: moves a specified `ItemStack` to the target inventory to the available slots – potentially splitting the source stack to top up stacks.
    * Items in the `ItemStack` are always of the same type. but do not necessarily have to be from the same inventory/slot.
    * The source item stack can be larger than `ItemTypeStaticProperties::maxStackSize`, because it can be an aggregation of multiple source slots (or other reasons).
    * Contrary to the first two transaction types. the auto transaction is **not atomic**. It's technically just an utility function that tries to execute multiple standard transactions. As a result, the function returns an item stack of items that failed to be moved.
* Standard and slot swap transactions are **atomic** (auto transaction is **not atomic**). This means that either the transaction succeeds and all requested items are moved, or the transaction fails and nothing happens.
* Transactions are always issued by the server, the client only requests them using `ACP::Inventory(-|Auto|SlotSwap)TransactionRequest` and receives (alongside with other clients subscribed to either source or target inventories) `ACP::Inventory(-|Auto|SlotSwap)TransactionReport`.
* A transaction is always performed by an actor (usually the client actor, but can also be system, root, entity, or say auto crafting station).
* There is a whole bunch of checks that have to succeed in order for the transaction to be approved:
  * Items have to be movable from the source position.
    * The source inventory must be accessible to the actor (`INA_CanAccess` with `InventoryAccessFlag::requestMoveFromAccess`).
      * Because the source items can be from multiple origins, the source item stack has to be split by the items origin and the sub-stacks have to be checked separately.
    * The inventory must allow withdrawal of the items (`INA_CanMoveFrom`).
      * Multiple origins ditto.
    * The moved items themselves must allow to be withdrawn (`IA_CanMoveFrom`).
  * Items have to be movable to the target position.
    * The target inventory must be accessible to the actor (`INA_CanAccess` with `InventoryAccessFlag::requestMoveToAccess`)
    * For standard transactions. the target slot must be empty or of the same item type and there must be enough free positions to `ItemTypeStaticProperties::maxStackSize`.
    * The target inventory must accept the deposit of the items (`INA_CanMoveTo`).
    * The moved items themselves must allow to be deposited (`IA_CanMoveTo`).

