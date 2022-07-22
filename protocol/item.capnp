@0xe8f660b53f85eb54;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";

struct ItemDataRecord {
	data @0 :AnyStruct;
}

struct ItemStack {
	count @0 :UInt16;
	id @1 :Util.ID; # Item type ID
	data @2 :List(ItemDataRecord); # Flat array of item data; item count * serialize data count
}

struct Inventory {
	slots @0 :List(ItemStack);
}

struct Item {
	id @0 :Util.ID;
	data @1 :List(ItemDataRecord);
}