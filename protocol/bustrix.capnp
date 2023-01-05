@0xb71e9a5645ea37a9;


# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using Chunk = import "chunk.capnp";

struct BustrixBlockWireData {
	wireType @0 :UInt16;
	connectingSides @1 :UInt8;
}

struct BustrixBlockData {
	cbi @0 :Chunk.ChunkBlockIndex;
  wires @1 :List(BustrixBlockWireData);
}

struct BustrixChunkData {
	blocks @0 :List(BustrixBlockData);
}