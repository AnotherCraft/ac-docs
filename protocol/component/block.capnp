@0xcfc2741a57206a7d;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "../util.capnp";
using Item = import "../item.capnp";
using Inventory = import "../inventory.capnp";
using Entity = import "../entity.capnp";

struct BTCDInventory {
	inv @0 :Inventory.Inventory;
}

struct BTCDStoredStringProperty {
	value @0 :Text;
}

struct BTCDStoredMaterialProperty {
	value @0 :Util.ID;
}

struct BTCDMinedItemDrop {
	itemPersistentHandle @0 :Util.PersistentHandle;
}

struct BTCDManualCraftingStation {
	inputInventory @0 :Inventory.Inventory;
	intermediateOutputInventory @1 :Inventory.Inventory;
	outputInventory @2 :Inventory.Inventory;
}

struct BTCDAutoCraftingStation {
	inputInventory @0 :Inventory.Inventory;
	intermediateOutputInventory @1 :Inventory.Inventory;
	outputInventory @2 :Inventory.Inventory;
	actor @3 :Entity.Actor;
	selectedRecipe @4 :Util.UID;
	queueSize @5 :Int32;
}

struct BTCDBustrixEndpoint {
	struct Connection {
		port @0 :Util.Identifier;
		wireType @1 :Util.ID;
	}
	
	connections @0 :List(Connection);
}

struct BTCDBustrixPowerPort {
	energy @0 :Float32;
}