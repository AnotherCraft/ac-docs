@0xde6a18a50d05c804;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using Game = import "game.capnp";
using World = import "world.capnp";
using Chunk = import "chunk.capnp";
using Entity = import "entity.capnp";

# Sent by the client, denoting that the player would like to enter the game
# Server responds with WorldEnter
struct WorldEnterRequest {

}

# Sent to the client when it firsts enters the game
struct WorldEnterSuccess {
	world @0 :World.WorldID;
	worldData @1 :World.WorldData;
	pos @2 :World.DecimalWorldPos;

	# Persistent handle of the player entity
	entityHandle @3 :Util.PersistentHandle;
}

struct PlayerCharacterPosition {
	world @0 :World.WorldID;
	pos @1 :World.DecimalWorldPos;
}