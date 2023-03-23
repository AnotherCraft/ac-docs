@0xcfc2741a57206a7d;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "../util.capnp";
using Item = import "../item.capnp";
using Inventory = import "../inventory.capnp";
using Actor = import "../actor.capnp";
using World = import "../world.capnp";

struct BTCDInventory {
	inv @0 :Inventory.Inventory;
}

struct BTCDStoredStringProperty {
	value @0 :Text;
}

struct BTCDStoredMaterialProperty {
	value @0 :Util.ID;
}

struct BTCDStoredRecipeProperty {
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

# C->S
struct BTCDManualCraftingStationMCraftingRequest {
	ctx @0 :World.ComponentWorldBlockContext;
	recipe @1 :Util.ID;	
	actionRequestID @2 :Actor.ActionRequestID;
}

struct BTCDAutoCraftingStation {
	inputInventory @0 :Inventory.Inventory;
	intermediateOutputInventory @1 :Inventory.Inventory;
	outputInventory @2 :Inventory.Inventory;
	actor @3 :Actor.Actor;
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

# S->C
struct BTCHorizontalOrientationMChanged {
	ctx @0 :World.ComponentWorldBlockContext;
	actor @1 :Util.PersistentHandle;
	data @2 :UInt8;
}

# S->C Signals the client that it should open a modular window handled by the provided component
struct BTCModularWindowMOpen {
	ctx @0 :World.ComponentWorldBlockContext;
}

struct BTCExplicitlyAttachedSidesMAttachSide {
	ctx @0 :World.ComponentWorldBlockContext;
	newData @1 :World.BlockSmallData;
}

# S->C
struct BTCDTreeTrunkMUpdate {
	ctx @0 :World.ComponentWorldBlockContext;
	newData @1 :World.BlockSmallData;
}