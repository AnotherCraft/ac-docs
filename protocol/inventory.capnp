@0xd9663aa30d52e450;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";

using InventorySlotID = UInt16;

struct ItemStack {
	type @0 :Util.ID; # Item type ID
	persistentHandles @1 :List(Util.PersistentHandle);
	data @2 :List(Util.AnyStructStruct); # Flat array of item data; item count * serialize data count
}

# C->S Denotes that the client needs the whole inventory to be serialized and sent to him (possible sync issue or something else)
struct InventoryRequest {
	inventory @0 :Util.PersistentHandle;
}

# C->S Denotes that the client needs an inventory slot be serialized and sent to him (possible sync issue or something else)
struct InventorySlotRequest {
	inventory @0 :Util.PersistentHandle;
}

# S->C, SAVE
struct Inventory {
	persistentHandle @0 :Util.PersistentHandle;
	slots @1 :List(ItemStack);
}

# S->C
struct InventorySlot {
	inventory @0 :Util.PersistentHandle;
	slot @1 :InventorySlotID;
	items @2 :ItemStack;
}

# C->S
struct InventorySlotSwapTransactionRequest {
	inventory1 @0 :Util.PersistentHandle;
	slot1 @1 :InventorySlotID;
	inventory2 @2 :Util.PersistentHandle;
	slot2 @3 :InventorySlotID;
}

# S->C
struct InventorySlotSwapTransactionReport {
	inventory1 @0 :Util.PersistentHandle;
	slot1 @1 :InventorySlotID;
	inventory2 @2 :Util.PersistentHandle;
	slot2 @3 :InventorySlotID;
}

# C->S
struct InventoryTransactionRequest {
	items @0 :List(Util.PersistentHandle);
	targetInventory @1 :Util.PersistentHandle;
	targetSlot @2 :InventorySlotID;
}

# S->C
# Marks that the items have been transferred to the last N positions in the stack on the target slot
struct InventoryTransactionReport {
	items @0 :List(Util.PersistentHandle);
	targetInventory @1 :Util.PersistentHandle;
	targetSlot @2 :InventorySlotID;
}