@0xf616a45c2d3f0826;

using Util = import "util.capnp";
using Util.client, Util.server, Util.Error, Util.UID, Util.Identifier;

using Game = import "game.capnp";

# Info about the game server. Automatically sent when the client logs in.
struct ServerInfo $server {
	version @0 :Text;
	name @1 :Text;
	description @2 :Text;
}

# Request from the client to login as a defined player.
# Server responds with Error or AuthChallenge
# Login is stored in the client connection context on the server and does not need to be sent again.
struct LoginRequest $client {
	login @0 :Text;
}

# Server challenging the player to authentize itself
# The client is supposed to take the password and send the hashed and salted password through AuthResponse.
# The password is stored on the server database as H(H(password + clientSalt) + serverSalt). ClientSalt is sent to the client in AuthChallenge. Inner hash is done on the client, outer hash is done on the server.
struct AuthChallenge $server {
	clientSalt @0 :Data;
}

# Second phase of client authentization - see AuthChallenge.
# Serve responds either with Error or LoginSuccess
struct AuthRequest $client {
	hashedPassword @0 :Data;
};

# Message from the server saying that the client is fully authenticated and has entered the Game (but not a world/doesn't have to be linked to the entity yet)
struct LoginSuccess $server {
	gameInfo @0 :Game.GameInfo;
	profiles @1 :List(PlayerProfile);
}

struct PlayerProfile {
	uid @0 :UID;
	name @1 :Text;
}

# Messages the server that the player wants to play as the given character
# After sending this message, it the server is expected to send the WorldEnterNotification
struct PlayerProfileSelectionRequest $client {
	profile @0 :UID;
}