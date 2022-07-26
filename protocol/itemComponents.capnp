@0xad434cbcc4c29100;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using Item = import "item.capnp";

struct ITCDStoredMaterialProperty {
	material @0 :Util.ID;
}

struct ITCDStoredNumberProperty {
	value @0 :Float32;
}

struct ITCDModularItem {
	inv @0 :Item.Inventory;
}

struct ITCDBag {
	inv @0 :Item.Inventory;
}