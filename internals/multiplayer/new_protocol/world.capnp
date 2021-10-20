@0xf6d86cb09b9d1484;

using Util = import "util.capnp";
using Util.client, Util.server, Util.Error, Util.UID, Util.Identifier;

# Annotation denoting that the struct is a message that requires the player to be present in a given world (thus the player must be logged in and authentized)
annotation world(struct) :Void;

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

# Message from the server notifying the client that it has entered a world
# Client does not initiate any world enters
struct WorldEnterNotification $server {
	world @0 :UID;
}

# Notification that the client has exited a world.
# This implicitly cancels any chunk requests and everything related to the world.
struct WorldExitNotification $server {
	world @0 :UID;
}

# Request for chunk data sent from client to server.
# The server responds with either ChunkData or ChunkRequestFailure.
# Once a chunk is requested, the client cannot request it again before he cancels the current request with ChunkUnrequest (or server responds with Error)
# The server does not have to respond immediately - it can delay the response for example until the chunk is generated, or to space out the large amounts of data to be sent.
struct ChunkRequest $client $world {
	world @0 :UID;
	pos @1 :List(ChunkPos);
}

# C->S message denoting that the client is no longer interested in given chunks.
# This means that the server should not send relevant ChunkData if they were not sent yet.
# This also means that the server should unsubscribe the client from receiving updates for given chunks.
struct ChunkUnrequest $client $world {
	world @0 :UID;
	pos @1 :List(ChunkPos);
}

# S->C message containing data for a given chunk
# As soon as server sends this message, it has to start sending the client all updates related to the chunk (the subscription is implicit). The subscription then gets cancelled with ChunkUnrequest.
struct ChunkData $server $world {
	world @0 :UID;
	pos @1 :ChunkPos;
	zOffset @2 :ChunkPosT;
	
	# Two alternative ways of passing chunk data:
	# rawData - just a flat array of all the block IDs in the chunkl
	# sparseData - only blocks that are visible to the player are sent (blocks that are not surrounded by opaque blocks from all sides)
	union {
		rawData :group {
			# Array of all the block IDs in the chunk, compressed by gzip
			rawBlockIDs @3 :Data;

			# Array of all the block small data in the chunk, compressed by gzip
			rawSmallData @4 :Data;
		}

		sparseData :group {
			struct SparseBlockRecord {
				# Position of the block in the chunk
				ix @0 :ChunkBlockIndex;

				# Block ID
				id @1 :BlockID;

				smallData @2 :BlockSmallData;
			}
			sparseBlocks @5 :List(SparseBlockRecord);

			# For optimization reasons, server also needs to tell the client which positions around the sparseBlocks are occupied with opaque blocks.
			# It doesn't have to tell what blocks those are, just that there are opaque blocks (so that the client knows it shouldn't render those sides of the blocks)
			occupiedBlocks @6 :List(ChunkBlockIndex);
		}
	}

	struct BigDataRecord {
		ix @0 :ChunkBlockIndex;

		# Arbitrary extra data for blocks that require it
		# Format of this data is not exactly specified and can be implemented differently for different block types
		data @1 :Data;
	}
	bigData @7 :List(BigDataRecord);
}

# Message from server to client to inform that a block has been created somewhere.
# The message means that the block has been changed from air to some block type.
# This message is ONLY sent by SERVER. Client does NOT inform that he created some blocks. It instead informs that the client did an action, the result of that action is determined by a server.
struct BlockCreatedNotification $server $world {
	world @0 :UID;
	pos @1 :BlockWorldPos;
	id @2 :BlockID;
	smallData @3 :BlockSmallData;
	bigData @4 :Data;

	# Reason why the block was created - can affect animation, sound effects etc
	reason @5 :Identifier;
}

# Message notyfing about block being destroyed
struct BlockDestroyedNotification $server $world {
	enum Reason {
		unknown @0;

		# Block was mined by someone
		mined @1;
	}

	world @0 :UID;
	pos @1 :BlockWorldPos;

	# Reason why the block was destroyed - can affect animation, sound effects etc
	reason @2 :Identifier;
}