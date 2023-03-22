@0x964f5a87dabc5dfc;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using World = import "world.capnp";
using Actor = import "actor.capnp";

# S->C, SAVE
struct Entity {
	type @0 :Util.ID;
	persistentHandle @1 :Util.PersistentHandle;
	world @2 :World.WorldID;
	pos @3 :World.DecimalWorldPos;
	data @4 :List(Util.AnyStructStruct);
	actor @5 :Actor.Actor;

	aimPos @6 :World.DecimalWorldPos;
}

# S->C when there's a world change for an entity.
# Sent to clients tracking source chunk or target chunk.
struct EntityWorldChange {
	entity @0 :Util.PersistentHandle;

	# When changing worlds, there's a high probability that the entity is not loaded on clients -> we include it in the world change event itself.
	entityData @1 :Entity;
	
	targetWorld @2 :World.WorldID;
	targetPos @3 :World.DecimalWorldPos;
	reason @4 :Util.Identifier;
}

# C->S when the client needs data for the given entity.
# For success, the entity has to be loaded on the server side and must be accessible to the client.
# Server responds with Entity if the request is valid.
struct EntityRequest {
	entity @0 :Util.PersistentHandle;
}