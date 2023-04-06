@0xb71e9a5645ea37a9;


# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using Chunk = import "chunk.capnp";
using World = import "world.capnp";

struct BustrixBlockWireData {
	wireType @0 :Util.ID;
	connectingSides @1 :UInt8;
}

struct BustrixBlockData {
  wires @0 :List(BustrixBlockWireData);
}

struct BustrixChunkData {
	struct BlockRecord {
		cbi @0 :Chunk.ChunkBlockIndex;
		data @1 :BustrixBlockData;
	}

	blocks @0 :List(BlockRecord);
}

# C->S on change, Storage
struct BustrixClientData {
	selectedPort @0 :Util.Identifier;
	selectedWireType @1 :Util.ID;
}

# S->C
struct BustrixWiringChanged {
	ctx @0 :World.WorldBlockContext;
	data @1 :BustrixBlockData;
}

# S->C
struct BustrixEndpointConnectionChanged {
	ctx @0 :World.WorldBlockContext;
	port @1 :Util.Identifier;
	wireType @2 :Util.ID; # 0 if disconnected
}