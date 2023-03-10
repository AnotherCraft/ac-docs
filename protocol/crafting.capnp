@0xe0973868673fb2ca;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using World = import "world.capnp";
using Item = import "item.capnp";

# C->S
struct HandCraftingRequest {
	recipe @0 :Util.ID;	
	count @1 :UInt8;
}