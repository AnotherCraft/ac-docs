@0xde6a18a50d05c804;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using Game = import "game.capnp";
using World = import "world.capnp";
using Chunk = import "chunk.capnp";
using Entity = import "entity.capnp";

# C->S Denoting that the player would like to enter the game
# Server responds with WorldEnter
struct WorldEnterRequest {

}

# S->C Sent to the client when it firsts enters the game
struct WorldEnterSuccess {
	world @0 :World.WorldID;
	worldData @1 :World.WorldData;
	pos @2 :World.DecimalWorldPos;

	# Player entity. The entity position might be null because the entity might not be in the world yet.
	entity @3 :Entity.Entity;

	# Client-specific data like UI bindings etc, completely managed by client
	playerClientData @4 :Data;
}

# C->S, SAVE Asking the server to store client data
struct PlayerClientData {
	data @0 :Data;
}

# SAVE Used for separately storing player character position
struct PlayerCharacterPosition {
	world @0 :World.WorldID;
	pos @1 :World.DecimalWorldPos;
}

# C->S
struct PlayerPositionReport {
	pos @0 :World.DecimalWorldPos;
	aimPos @1 :World.DecimalWorldPos;
}