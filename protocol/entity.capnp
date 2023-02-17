@0x964f5a87dabc5dfc;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using World = import "world.capnp";

# S->C, also used for serialization generally
struct Entity {
	type @0 :Util.ID;
	persistentHandle @1 :Util.PersistentHandle;
	world @2 :World.WorldID;
	pos @3 :World.DecimalWorldPos;
	data @4 :List(Util.AnyStructStruct);
	actor @5 :Actor;

	aimPos @6 :World.DecimalWorldPos;
}

struct Actor {
	persistentHandle @0 :Util.PersistentHandle;
	statusEffects @1 :ActorStatusEffects;
	stats @2 :ActorStats;
}

struct ActorStatusEffects {
	list @0 :List(ActorStatusEffect);
}

struct ActorStatusEffect {
	type @0 :Util.ID;
	data @1 :List(Util.AnyStructStruct);
}

struct ActorStats {
	persistentStats @0 :List(ActorStat);
}

struct ActorStat {
	type @0 :Util.UID;
	value @1 :Float32;
}

# S->C when there's a world change for an entity.
# Sent to clients tracking source chunk or target chunk.
struct EntityWorldChange {
	entity @0 :Util.PersistentHandle;
	targetWorld @1 :World.WorldID;
	targetPos @2 :World.DecimalWorldPos;
	reason @3 :Util.Identifier;
}

# C->S when the client needs data for the given entity.
# For success, the entity has to be loaded on the server side and must be accessible to the client.
# Server responds with Entity if the request is valid.
struct EntityRequest {
	entity @0 :Util.PersistentHandle;
}