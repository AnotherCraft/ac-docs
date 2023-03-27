@0x8688bfcc7119ddf4;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using World = import "world.capnp";
using Item = import "item.capnp";

using ActionRequestID = UInt64;

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
	stats @0 :List(ActorStat);
	flags @1 :List(Util.UID);
}

struct ActorStat {
	type @0 :Util.UID;
	value @1 :Float32;
}

# S->C
struct ActorActionUpdate {
	actor @0 :Util.PersistentHandle;
}

struct ActorInteractionData {
	itemStack @0 :Item.ItemHandleStack;
	action @1 :Util.Identifier;
	origin @2 :Util.Identifier;
	ray @3 :World.CollisionRayState;
	isRepeated @4 :Bool;
	params @5 :Data; # Json object
}

# C->S Sent when the player wants to interactswith an item (IA_Action)
struct ItemActionRequest {
	interactionData @0 :ActorInteractionData;
	actionRequestID @1 :ActionRequestID;
}

# C->S Sent when the player wants to interact with a block (BA_Interact)
struct BlockInteractionRequest {
	ctx @0 :World.WorldBlockContext;
	interactionData @1 :ActorInteractionData;
	actionRequestID @2 :ActionRequestID;
}

struct ItemEquipRecord {
	items @0 :Item.ItemHandleStack;
	target @1 :Util.Identifier;
	flags @2 :UInt8;
}

# For S->C serialization purposes
struct ActorAction {
	handle @0 :Util.PersistentHandle;
	startTime @1 :Util.GameTime;
	endTime @2 :Util.GameTime;
	flags @3 :UInt16;
	name @4 :Util.TranslatableString;
	animation @5 :Util.Identifier;
	origin @6 :Util.Identifier;
	itemEquipRecords @7 :List(ItemEquipRecord);
	actionRequestID @8 :ActionRequestID;
}

# S->C
struct ActorCurrentActionChanged {
	actor @0 :Util.PersistentHandle;
	action @1 :ActorAction;
}

struct ActorActionEnded {
	actor @0 :Util.PersistentHandle;
	reason @1 :UInt8;
	actionRequestID @2 :ActionRequestID;
}

# C->S
struct ActorActionFinishRequest {

}

# C->S
struct ActorActionCancelRequest {
	# If set, will cancel the action only the origin matches
	originCondition @0 :Util.Identifier;
}

# S->C Sent whenever the status effect has been changed
struct ActorStatusEffectUpdate {
	actor @0 :Util.PersistentHandle;
	effect @1 :ActorStatusEffect;
}

# S->C
struct ActorStatusEffectRemoved {
	actor @0 :Util.PersistentHandle;
	effect @1 :Util.ID;
}