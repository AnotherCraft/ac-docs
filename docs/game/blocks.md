# Blocks

See [worlds](worlds.md) to read how blocks are stored. The short version:

* 16×16×256 chunks, each chunk can have a different z offset
* 2 bytes of BlockID
* 1 byte of BlockSmallData
* Unlimited BlockBigData – but use small data whenever possible

New blocks can be created using `BA_Init::exect`. Blocks can be destroyed using `BA_Uninit::exec`.

## Multiplayer synchronization

* The player first receives block information as a part of the `ACP::Chunk` message. At the same time, he also gets subscribed to the chunk and will receive all further updates until `ACP::ChunkUnrequest` is received.
  * In the future, there should also be a mechanism of auto unsubscribing from the server-side (for example when the client gets too far from the chunk) and notifying the client about it.
* Then, further chunk updates are emitted automatically as a part of the respective callbacks. For example:
  * `BA_Init` broadcasts `ACP::BlockInit`
  * `BA_Uninit` broadcasts `ACP::BlockUninit`
  * `BA_SetProperty` broadcasts `ACP::BlockSetProperty`
* Block components can also broadcast their own messages if they want.