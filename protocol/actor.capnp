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

struct ActorInteractionData {
	itemStack @0 :Item.ItemHandleStack;
	action @1 :Util.Identifier;
	origin @2 :Util.Identifier;
	ray @3 :World.CollisionRayState;
	isRepeated @4 :Bool;
	params @5 :Data; # Json object
}

# C->S
struct ItemActionRequest {
	interactionData @0 :ActorInteractionData;
}