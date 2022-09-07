@0xbd38e43ed6973c0d;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "../util.capnp";
using Item = import "../item.capnp";

struct ETCDItem {
	inv @0 :Item.Inventory;
}

struct ETCDPhysics {
	speed @0 :Util.Vector3F;
}

struct ETCDCharacter {
	storageInventory @0 :Item.Inventory;
	equipmentInventory @1 :Item.Inventory;
}

struct ETCDPlayer {

}

struct ETCDTreeSapling {
	seed @0 :UInt64;
	remainingGrowPoints @1 :Int32;
	saplingType @2 :Util.ID;
}

struct ETCDDumbAnimalAI {
	freakOutTimeout @0 :Util.GameTime;
}

struct ETCDLootInventory {
	lootInventory @0 :Item.Inventory;
}