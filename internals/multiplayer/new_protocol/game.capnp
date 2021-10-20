@0xe7e20011fc8e7fa5;

using Util = import "util.capnp";
using Util.client, Util.server, Util.Error, Util.UID, Util.Identifier;

# Information the client requires about a game
# This is not a packet on its own, it's sent inside Session.LoginSuccess
struct GameInfo {
	mods @3 :List(ModInfo);

	blockMapping @0 :IDMapping;
	itemMapping @1 :IDMapping;
	entityMapping @2 :IDMapping;
}

struct IDMapping {
	# index -> UID mapping list (indexing from 0). Can contain empty records denoting that a given ID is not occupied
	uids @0 :List(UID);
}

struct ModInfo {
	uid @0 :UID;
	version @1 :Text;
}