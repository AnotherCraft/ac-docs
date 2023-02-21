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