@0xde6a18a50d05c804;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using Game = import "game.capnp";
using World = import "world.capnp";
using Chunk = import "chunk.capnp";
using Entity = import "entity.capnp";
using Actor = import "actor.capnp";
using Item = import "item.capnp";

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
struct HandCraftingRequest {
	recipe @0 :Util.ID;	
	actionRequestID @1 :Actor.ActionRequestID;
}

# C->S
struct ItemsThrowRequest {
	items @0 :Item.ItemHandleStack;
	targetPos @1 :World.DecimalWorldPos; # Where the thrown items should land
}

# C->S
struct PlayerHandSlotUpdateRequest {
	leftHandSlot @0 :Text;
	rightHandSlot @1 :Text;
}

struct ControlsData {
	struct ControlValue {
		control @0 :Util.Identifier;
		value @1 :Float32;
	}
	nonzeroControlValues @0 :List(ControlValue);
	onControls @1 :List(Util.Identifier);
	forwardNormal @2 :Util.Vector3F;
}

# C->S
struct PlayerControlsReport {
	controlsData @0 :ControlsData;
	aimPos @1 :World.DecimalWorldPos;
	clientStepID @2 :Util.GameStepID;
}

# S->C
struct PlayerControlsPingback {
	clientStepID @0 :Util.GameStepID;
	serverStepDiff @1 :Util.GameStepID; # Server steps between the current and last pingback
}