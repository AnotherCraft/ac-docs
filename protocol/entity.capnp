@0x964f5a87dabc5dfc;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using World = import "world.capnp";

struct Entity {
	type @0 :Util.ID;
	persistentHandle @1 :Util.PersistentHandle;
	pos @2 :World.EntityWorldPos;
	data @3 :List(Util.AnyStructStruct);
	actor @4 :Actor;
}

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