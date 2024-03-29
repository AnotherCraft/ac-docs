@0xef8bd48cdcfa51c8;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";
using Entity = import "entity.capnp";
using World = import "world.capnp";

using ChunkPos = World.ChunkPos;
using ChunkPosT = World.ChunkPosT;
using ChunkBlockIndex = World.ChunkBlockIndex;

using BlockID = World.BlockID;
using BlockSmallData = World.BlockSmallData;

struct BlockExtraSmallData {
	data @0 :List(BlockSmallData);
}

# Request for chunk data sent from client to server.
# The server (eventually) responds with ChunkData.
# The server does not have to process the request immediately - it can delay the response for example until the chunk is generated, or to space out the large amounts of data to be sent.
# After the request is processed, the client starts automatically receiving all updates regarding the chunk, entities inside it etc (until ChunkUnrequest is processed).
# Once a chunk is requested, the client cannot request it again before he cancels the current request with ChunkUnrequest (or server responds with Error)
struct ChunkRequest {
	world @0 :Util.UID;
	positions @1 :List(ChunkPos);
}

# C->S message denoting that the client is no longer interested in given chunks.
# This means that the server should not send relevant ChunkData if they were not sent yet.
# This also means that the server should unsubscribe the client from receiving updates for given chunks.
struct ChunkUnrequest {
	world @0 :Util.UID;
	positions @1 :List(ChunkPos);
}

# S->C message containing data for a given chunk
# S->C, SAVE
# As soon as server sends this message, it has to start sending the client all updates related to the chunk (the subscription is implicit). The subscription then gets cancelled with ChunkUnrequest.
struct Chunk {
	world @0 :World.WorldID;
	pos @1 :ChunkPos;
	zOffset @2 :ChunkPosT;
	flags @3 :UInt8;

	struct SparseBlockRecord {
    cbi @0 :ChunkBlockIndex;
    type @1 :BlockID;
    smallData @2 :BlockSmallData;
  }
	
	# Two alternative ways of passing chunk data:
	# rawData - just a flat array of all the block IDs in the chunkl
	# sparseData - only blocks that are visible to the player are sent (blocks that are not surrounded by opaque blocks from all sides)
	union {
		rawData :group {
			# Flat array of all the block IDs in the chunk (65536)
			rawBlockIDs @4 :Data;

			# Flat array of all the block small data in the chunk (65536)
			rawSmallData @5 :Data;
		}

		sparseData :group {
			sparseBlocks @6 :List(SparseBlockRecord);

			# For optimization reasons, server also needs to tell the client which positions around the sparseBlocks are occupied with opaque blocks.
			# It doesn't have to tell what blocks those are, just that there are fully opaque blocks (so that the client knows it shouldn't render those sides of the blocks)
			occupiedBlocks @7 :List(ChunkBlockIndex);
		}
	}

	# Extra explicitly serialized data by the components
	struct ExtraDataRecord {
		cbi @0 :ChunkBlockIndex;
		data @1 :List(Util.AnyStructStruct); # List of extra data, can also incorporate extra small data (List(BlockExtraSmallData)). Order of the data is determined by the #blockUID_serializeDataMapping
	}
	extraData @8 :List(ExtraDataRecord);

	entities @9 :List(Entity.Entity);

	subsystemData @10 :List(Util.AnyStructStruct);
}