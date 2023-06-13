# Multiplayer synchronization

* Server is fully authoritative for everything.

* All physics, collisions and such are fully deterministic and the physics is executed both on client and server

  * Server occasionally sends physics updates to the clients to make sure that they're kept in sync. In the meantime the client predicts the physics locally.

* Stuff like block breaking/building, actor stats updates, and so on is always initiated from the server and is not predicted on the client.

* At the end of each step, `ACP::StepSync` message is broadcasted from the server to the clients.

  * Clients keep buffer of incoming messages and always process one step worth of messages on the beginning of their game step. This is to combat network jitter.
    * In the future, a strategy that gradually reduces the buffer size when it gets larger than one could be implemented.
* Login procedure is implemented in `PrototypeResources::initGame2`.


##  Player movement

* Server is fully authoritative in player movement.
* Server receives controls data each game step and moves the player accordingly.
* Client however also processes the movement inputs right away, not waiting for the server response/update.
* When the client receives update of the player position/speed/movement data from the server, it replays  some of the inputs because of client-server delay (https://www.gabrielgambetta.com/client-side-prediction-server-reconciliation.html).
* Server keeps buffer of received controls snapshots from the client and always processes a single message each step (to combat network jitter).
  * In the future, a strategy that gradually reduces the buffer size when it gets larger than one could be implemented.

## Entity, item, inventory updates

Entities and items use a bit different approach, because they are mobile and can be moved between chunks.

* Each entity and item and inventory that is sent to a client has a unique persistent UID.
* Inventories are not considered to be self-sustaining, they can get to client only as a part of something else, for example chest -> inventory (`INC_BlockInventory`) inside block, bag -> inventory inside item (`INC_BagInventory`/`INC_ItemNestedInventory`), entity inventory (`INC_EntityPublic/Private/EquipmentInventory`). There are components for the inventory that handle obtaining the subscribers list from parent objects.
  * Inventories are sent to clients as a part of the initial serialization of a given component and do not really have any events
* Items are also not self-sustaining and have to (almost) always be inside an inventory to be considered.

## Block, item, entity updates

* Entity position updates are realized through their respective physics components (currently we can have `ETC_Physics` or `ETC_RayPhysics`).
  * These updates are issued through the `EA_SendUpdate` callback, which is called from `World_ServerComponent::step`.
  * These updates are currently sent each frame , but that's not necessary, because physics are calculated on clients as well – the system could employ a round-robin updates sending of different chunks to reduce network bandwidth.