@0xb33b5c72d443b7ae;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using World = import "world.capnp";

using BlockID = World.BlockID;
using BlockSmallData = World.BlockSmallData;

# S->C
struct BlockInit {
	ctx @0 :World.WorldBlockContext;
	reason @1 :Util.Identifier;
	playSound @2 :Bool;
	sourceItem @3 :Util.PersistentHandle;
	ray @4 :World.CollisionRayState;
	actor @5 :Util.PersistentHandle;
	properties @6 :Util.IdentifierVariantList;
	blockID @7 :BlockID;

	smallData @8 :BlockSmallData;
	extraData @9 :List(Util.AnyStructStruct);
}

# S->C
struct BlockUninit {
	ctx @0 :World.WorldBlockContext;
	actor @1 :Util.PersistentHandle;
	reason @2 :Util.Identifier;
	playSound @3 :Bool;
}

# S->C
struct BlockDamageReceived {
	ctx @0 :World.WorldBlockContext;
	actor @1 :Util.PersistentHandle;
	item @2 :Util.PersistentHandle;
	ray @3 :World.CollisionRayState;
}

# S->C
struct BlockMiningProgressChanged {
	ctx @0 :World.WorldBlockContext;
	newValue @1 :Float32;
}

# S->C
struct BlockSetProperty {
	ctx @0 :World.WorldBlockContext;
	property @1 :Util.Identifier;
	value @2 :Util.Variant;
}