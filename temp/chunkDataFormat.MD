# Format of the .chunkData file
Everything is in little endian

## Root
* `chunkCount: UInt32` number of chunks contained in the file
* `chunks: ChunkData[chunkCount]` - variable length record array, each record contains data of one chunk
	* Chunks are **not in any particular order**

## `ChunkData`
Header:
* `"CHUNKHEADER"` - 11-byte constant at the beginning at each chunk record
* `pos.x: Int32` - position X of the chunk (in chunks, so 16x block)
* `pos.y: Int32` - ditto
* `zOffset: Int32` - Z offset of the chunk (in blocks, always a multiple of 16)

Body:
* `"CHUNKDATA"` - 9-byte constant
* `dataSize: UInt32` - size of the data that follows in bytes
* `data: compressed UInt16[65536]` - compressed chunk data
	* Compression is done through zlib in default compression rate
	* The idea is that you read `dataSize` bytes, then call decompress over it, which should give you exactly `65536 * sizeof(UInt16)` bytes
	* The values represent block IDs, as defined in the `worldGenOut.json` block mapping. 0 = air.
	* The blocks are in X-Y-Z order, so `index = 0xZZYX`