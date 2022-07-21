@0xf6d86cb09b9d1484;

# Put everything into the "acp" (AC Protocol) namespace
using Cxx = import "/capnp/c++.capnp";
$Cxx.namespace("ACP");

using Util = import "util.capnp";

using BlockWorldPosT = Int32;
struct BlockWorldPos {
	x @0 :BlockWorldPosT;
	y @1 :BlockWorldPosT;
	z @2 :BlockWorldPosT;
}

using ChunkPosT = Int32;
struct ChunkPos {
	x @0 :ChunkPosT;
	y @1 :ChunkPosT;
}

using ChunkBlockIndex = UInt16;

using BlockID = UInt16;
using BlockSmallData = UInt16;

# Extra data a block wants to serialize aside from the 2 byte small data
struct BlockBigData {
	smallData @0 :List(BlockSmallData);
	bigData @1 :List(BigDataRecord);

	# Capnp doesn't support List(AnyStruct)
	struct BigDataRecord {
		data @0 :AnyStruct;
	}
}

# Request for chunk data sent from client to server.
# The server responds with either ChunkData or ChunkRequestFailure.
# Once a chunk is requested, the client cannot request it again before he cancels the current request with ChunkUnrequest (or server responds with Error)
# The server does not have to respond immediately - it can delay the response for example until the chunk is generated, or to space out the large amounts of data to be sent.
struct ChunkRequest {
	world @0 :Util.UID;
	pos @1 :List(ChunkPos);
}

# C->S message denoting that the client is no longer interested in given chunks.
# This means that the server should not send relevant ChunkData if they were not sent yet.
# This also means that the server should unsubscribe the client from receiving updates for given chunks.
struct ChunkUnrequest {
	world @0 :Util.UID;
	pos @1 :List(ChunkPos);
}

# S->C message containing data for a given chunk
# As soon as server sends this message, it has to start sending the client all updates related to the chunk (the subscription is implicit). The subscription then gets cancelled with ChunkUnrequest.
struct ChunkData {
	pos @0 :ChunkPos;
	zOffset @1 :ChunkPosT;

	struct SparseBlockRecord {
    # Position of the block in the chunk
    ix @0 :ChunkBlockIndex;

    # Block ID
    id @1 :BlockID;

    smallData @2 :BlockSmallData;
  }
	
	# Two alternative ways of passing chunk data:
	# rawData - just a flat array of all the block IDs in the chunkl
	# sparseData - only blocks that are visible to the player are sent (blocks that are not surrounded by opaque blocks from all sides)
	union {
		rawData :group {
			# Flat array of all the block IDs in the chunk (65536)
			rawBlockIDs @2 :Data;

			# Flat array of all the block small data in the chunk (65536)
			rawSmallData @3 :Data;
		}

		sparseData :group {
			sparseBlocks @4 :List(SparseBlockRecord);

			# For optimization reasons, server also needs to tell the client which positions around the sparseBlocks are occupied with opaque blocks.
			# It doesn't have to tell what blocks those are, just that there are fully opaque blocks (so that the client knows it shouldn't render those sides of the blocks)
			occupiedBlocks @5 :List(ChunkBlockIndex);
		}
	}

	struct BigDataRecord {
		ix @0 :ChunkBlockIndex;

		# Arbitrary extra data for blocks that require it
		# Format of this data is not exactly specified and can be implemented differently for different block types
		data @1 :BlockBigData;
	}
	bigData @6 :List(BigDataRecord);
}

struct WorldChunkData {
	world @0 :Util.UID;
	data @1 :ChunkData;
}

# Message from server to client to inform that a block has been created somewhere.
# The message means that the block has been changed from air to some block type.
# This message is ONLY sent by SERVER. Client does NOT inform that he created some blocks. It instead informs that the client did an action, the result of that action is determined by a server.
struct BlockInit {
	world @0 :Util.UID;
	pos @1 :BlockWorldPos;
	blockID @2 :BlockID;
	smallData @3 :BlockSmallData;
	bigData @4 :BlockBigData;

	# Reason why the block was created - can affect animation, sound effects etc
	reason @5 :Util.Identifier;
}

# Message notyfing about block being destroyed
struct BlockUninit {
	world @0 :Util.UID;
	pos @1 :BlockWorldPos;

	# Reason why the block was destroyed - can affect animation, sound effects etc
	reason @2 :Util.Identifier;
}