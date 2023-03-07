@0xb33b5c72d443b7ae;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using World = import "world.capnp";

using BlockID = World.BlockID;
using BlockSmallData = World.BlockSmallData;

# S->C
struct BlockUninit {
	world @0 :World.WorldID;
	pos @1 :World.BlockWorldPos;
	actor @2 :Util.PersistentHandle;
	reason @3 :Util.Identifier;
	playSound @4 :Bool;
}

# S->C
struct BlockDamageReceived {
	world @0 :World.WorldID;
	pos @1 :World.BlockWorldPos;
	actor @2 :Util.PersistentHandle;
	item @3 :Util.PersistentHandle;
	ray @4 :World.CollisionRayState;
}

# S->C
struct BlockMiningProgressChanged {
	world @0 :World.WorldID;
	pos @1 :World.BlockWorldPos;
	newValue @2 :Float32;
}