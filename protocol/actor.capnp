@0x8688bfcc7119ddf4;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using World = import "world.capnp";
using Item = import "item.capnp";

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

# C->S Sent when the player wants to interacts with an item (IA_Action)
struct ItemActionRequest {
	interactionData @0 :ActorInteractionData;
}

struct ItemEquipRecord {
	items @0 :Item.ItemHandleStack;
	target @1 :Util.Identifier;
	flags @2 :UInt8;
}

# For S->C serialization purposes
struct ActorAction {
	handle @7 :Util.PersistentHandle;
	startTime @0 :Util.GameTime;
	endTime @1 :Util.GameTime;
	flags @2 :UInt16;
	name @3 :Util.TranslatableString;
	animation @4 :Util.Identifier;
	origin @5 :Util.Identifier;
	itemEquipRecords @6 :List(ItemEquipRecord);
}

# S->C
struct ActorActorActionChanged {
	actor @0 :Util.PersistentHandle;
	action @1 :ActorAction;
	currentTime @2 :Util.GameTime;
}