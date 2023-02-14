@0xf616a45c2d3f0826;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using Game = import "game.capnp";
using World = import "world.capnp";
using Chunk = import "chunk.capnp";

# First message, automatically sent when a client connects to a server.
struct ServerInfo {
	serverName @0 :Text;
	gameVersion @1 :Text;
}

# Request from the client to login.
struct AuthRequest {
	login @0 :Text;
}

struct AuthResponse {
	success @0 :Bool;
}

# Sent to client to inform him where his player entity can be found (the entity itself will be sent with the chunk upon request)
struct PlayerEntityInfo {
	world @0 :World.WorldID;
	chunk @1 :Chunk.ChunkPos;
	handle @2 :Util.PersistentHandle;
}