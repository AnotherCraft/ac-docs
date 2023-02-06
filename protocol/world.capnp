@0xf6d86cb09b9d1484;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using Entity = import "entity.capnp";

using BlockWorldPosT = Int32;
struct BlockWorldPos {
	x @0 :BlockWorldPosT;
	y @1 :BlockWorldPosT;
	z @2 :BlockWorldPosT;
}

using DecimalWorldPosT = Float32;
struct DecimalWorldPos {
	x @0 :Int64;
	y @1 :Int64;
	z @2 :Int64;
}

using ChunkPosT = Int32;
struct ChunkPos {
	x @0 :ChunkPosT;
	y @1 :ChunkPosT;
}

using WorldID = Util.Identifier;

using ChunkBlockIndex = UInt16;

using BlockID = UInt16;
using BlockSmallData = UInt8;