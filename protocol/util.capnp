@0xe25fc37df132e181;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

# Identifiers serve to replace often used strings (user defined enums etc) with a single integer value - to speed up working with them and to reduce transmission size.
# The idea is that there is a sparse String <-> Identifier mapping. This mapping can be different for client->server and server->client messages.
# Before an identifier is first used, an appropriate mapping must be sent to the other side using the IdentifierMapping message.
# The idea is that when client/server is about to send a message with an identifier that has not been used yet, it prepares a new IdentifierMapping packet and enqueues it BEFORE the packet that first uses the mapping.
using Identifier = UInt32;

# Handle for uniquely identifying various object like item instances, inventories and such, persistent across the whole game
using PersistentHandle = UInt64;

struct Message {
	type @0 :Identifier;
	data @1 :AnyStruct;
}

# See Identifier
struct ProtocolStateUpdate {
	struct IdentifierMapping {
		id @0 :Identifier;
		text @1 :Text;
	}
	identifierMappings @0 :List(IdentifierMapping);
}

# Unique global identifier. It is supposed to be prefixed with the type of the identifier - for example 'block.XXX' or 'world.XX' or 'item.XXX'
using UID = Identifier;

using ID = UInt16;

using GameTime = Int64;

struct Variant {
	union {
		null @0 :Void;
		int32 @1 :Int32;
		float32 @2 :Float32;
		string @3 :Text;
		data @4 :Data;
		bool @5 :Bool;
		ptr @6 :AnyPointer;
	}
}

struct AnyPointerStruct {
	data @0 :AnyPointer;
}

struct AnyStructStruct {
	data @0 :AnyStruct;
}

struct Error {
	# UID of the error - something like error.login.badPassword
	uid @0 :Identifier;

	# General message of the error for debugging purposes
	message @1 :Text;

	struct Param {
		key @0 :Identifier;
		value @1 :Variant;
	}
	params @2 :List(Param);
}

struct Vector3F {
	x @0 :Float32;
	y @1 :Float32;
	z @2 :Float32;
}