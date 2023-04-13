@0xf6d86cb09b9d1484;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";

using BlockWorldPosT = Int32;
struct BlockWorldPos {
	x @0 :BlockWorldPosT;
	y @1 :BlockWorldPosT;
	z @2 :BlockWorldPosT;
}

struct DecimalWorldPos {
	x @0 :Util.Decimal;
	y @1 :Util.Decimal;
	z @2 :Util.Decimal;
}

using ChunkPosT = Int32;
struct ChunkPos {
	x @0 :ChunkPosT;
	y @1 :ChunkPosT;
}

using WorldID = Util.Identifier;

using ChunkBlockIndex = UInt16;

using BlockID = UInt16;
using BlockSmallData = UInt8;

struct WorldData {
	worldgen @0 :Util.Identifier;
	seed @1 :UInt64;
}

struct CollisionRayState {
	hitType @0 :UInt8;
	hitPos @1 :DecimalWorldPos;
	hitSide @2 :UInt8;
	hitBlockPos @3 :BlockWorldPos;
	hitEntity @4 :Util.PersistentHandle;
	hitColliderArg @5 :Int32;
	distance @6 :Float32;
}

struct WorldBlockContext {
	world @0 :WorldID;
	pos @1 :BlockWorldPos;
}

struct ComponentWorldBlockContext {
	world @0 :WorldID;
	pos @1 :BlockWorldPos;
	component @2 :Util.Identifier;
}

# S->C Instruction that the client should play a sound
struct SoundEvent {
	sound @0 :Util.Identifier;
	pos @1 :DecimalWorldPos; # If not set -> all around
	speed @2 :DecimalWorldPos; # For doppler effect
	volume @3 :Float32;
	bus @4 :Util.Identifier;

	union {
		block @5 :WorldBlockContext; # If set, the sound should be characteristic to the given block
		entity @6 :Util.PersistentHandle; # If set, the sound should be characteristic to the given entity
	}
}