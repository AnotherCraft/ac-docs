@0xe7e20011fc8e7fa5;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";

# Information the client requires about a game
# This is not a packet on its own, it's sent inside Session.LoginSuccess
struct GameInfo {
	mods @0 :List(ModInfo);
	protocolState @1 :Util.ProtocolStateUpdate;
	idMappings @2 :IDMappingList;
}

struct IDMapping {
	# index -> UID mapping list (indexing from 0). Can contain empty records denoting that a given ID is not occupied
	uids @0 :List(Util.UID);
}

struct IDMappingList {
	struct Record {
		manager @0 :Util.Identifier;
		mapping @1 :IDMapping;
	}
	list @0 :List(Record);
}

struct ModInfo {
	uid @0 :Util.UID;
	version @1 :Text;
}

struct SaveSyncData {
	persistentHandleCounter @0 :Util.PersistentHandle;
	gameTime @1 :Util.GameTime;
}