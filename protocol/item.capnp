@0xe8f660b53f85eb54;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";

struct Item {
	type @0 :Util.ID;
	persistentHandle @1 :Util.PersistentHandle;
	data @2 :List(Util.AnyStructStruct);
}

struct ItemStack {
	type @0 :Util.ID; # Item type ID
	persistentHandles @1 :List(Util.PersistentHandle);
	data @2 :List(Util.AnyStructStruct); # Flat array of item data; item count * serialize data count
}

struct ItemHandleStack {
	handles @0 :List(Util.PersistentHandle);
}

struct ItemPropertySet {
	item @0 :Util.PersistentHandle;
	property @1 :Util.Identifier;
	value @2 :Util.Variant;
}