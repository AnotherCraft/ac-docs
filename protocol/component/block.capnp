@0xcfc2741a57206a7d;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "../util.capnp";
using Item = import "../item.capnp";
using Entity = import "../entity.capnp";

struct BTCDInventory {
	inv @0 :Item.Inventory;
}

struct BTCDStoredStringProperty {
	value @0 :Text;
}

struct BTCDMinedItemDrop {
	itemPersistentHandle @0 :Util.PersistentHandle;
}

struct BTCDManualCraftingStation {
	inputInventory @0 :Item.Inventory;
	intermediateOutputInventory @1 :Item.Inventory;
	outputInventory @2 :Item.Inventory;
}

struct BTCDAutoCraftingStation {
	inputInventory @0 :Item.Inventory;
	intermediateOutputInventory @1 :Item.Inventory;
	outputInventory @2 :Item.Inventory;
	actor @3 :Entity.Actor;
	selectedRecipe @4 :Util.UID;
	queueSize @5 :Int32;
}