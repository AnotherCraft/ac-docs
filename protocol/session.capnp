@0xf616a45c2d3f0826;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using Game = import "game.capnp";
using World = import "world.capnp";
using Chunk = import "chunk.capnp";
using Entity = import "entity.capnp";

# S->C First message, automatically sent when a client connects to a server.
struct ServerInfo {
	appID @0 :Text; # AnotherCraft server
	serverName @1 :Text;
	gameVersion @2 :Text;
}

# C->S Request from the client to login.
struct AuthRequest {
	login @0 :Text;
}

# S->C
struct AuthResponse {
	success @0 :Bool;
}