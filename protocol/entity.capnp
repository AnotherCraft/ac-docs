@0x964f5a87dabc5dfc;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";

using EntityWorldPosT = Float32;
struct EntityWorldPos {
	x @0 :Float32;
	y @1 :Float32;
	z @2 :Float32;
}

struct Entity {
	type @0 :Util.ID;
	persistentHandle @1 :Util.PersistentHandle;
	pos @2 :EntityWorldPos;
	data @3 :List(Util.AnyStructStruct);
	actor @4 :Actor;

	aimPos @5 :EntityWorldPos;
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