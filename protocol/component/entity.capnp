@0xbd38e43ed6973c0d;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "../util.capnp";
using Item = import "../item.capnp";
using Inventory = import "../inventory.capnp";

struct ETCDItem {
	inv @0 :Inventory.Inventory;
}

struct ETCDPhysics {
	speed @0 :Util.Vector3F;
}

struct ETCDCharacter {
	storageInventory @0 :Inventory.Inventory;
	equipmentInventory @1 :Inventory.Inventory;
}

struct ETCDPlayer {
	handCraftingInputInventory @0 :Inventory.Inventory;
	handCraftingIntermediateOutputInventory @1 :Inventory.Inventory;
	handCraftingOutputInventory @2 :Inventory.Inventory;
}

struct ETCDTreeSapling {
	seed @0 :UInt64;
	remainingGrowPoints @1 :Int32;
	queuedGrowPoints @3: Int32;
	saplingType @2 :Util.ID;
}

struct ETCDDumbAnimalAI {
	freakOutTimeout @0 :Util.GameTime;
}

struct ETCDLootInventory {
	lootInventory @0 :Inventory.Inventory;
}

struct ETCDDespawnTimeout {
	despawnTime @0 :Util.GameTime;
}

struct ETCDRayPhysics {
	speed @0 :Util.Vector3F;
	spawnTime @1 :Util.GameTime;
	spawningEntity @2 :Util.PersistentHandle;
	hasHit @3 :Bool;
}