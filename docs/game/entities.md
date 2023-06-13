# Entities

Entities are objects in the world that are not restricted to being static and aligned to the voxel grid. Typical examples of entities are players and NPCs.

* Entities can move around and between the worlds.
* Entity position is decimal. 
* Entities can have physics/collisions (implemented in `ETC_Physics` and `ETC_RayPhysics`)
* Entities can contain inventories and items (`ETC_EntityPublic/Private/EquipmentInventory`)
* Entities can be actors (but anything can be/contain an actor, really)
  * Actors can execute actions (crafting, inventory transactions) and have stats (health, stamina, strength, ...).
* Entities have persistent handles and uniquely identify each entity within a game.

## Creating and moving entities

* When entity is created, it happens in void (not assigned to any world). The entity is then moved to a world using `EntityInstance::moveToWorld` function, emitting `EA_WorldChange` callbacks.
  * Entity can subsequently be moved between the worlds using the same function.
  * This also means that the client never really receives `EA_Init` (though it executes it locally to create the entity from serialized data).
* Entity can then be moved within a world using the `setPosition` function.
  * Trying to move outside a loaded area fails.
  * When the source and target positions are not in the same chunk, the entity is moved between chunks.
  * The function emits `EA_PositionChanged` callback, but currently doesn't broadcast any message – that's because it should rather be handled by the entities that cause the position changes. And overall, position reports should use `EA_SendUpdate` mechanism issued by `World_ServerComponent`.
    * However there's currently no mechanism to notify the subscribers of the previous chunk the entity was in (should be added in the future).

## Multiplayer synchronization

* Entities are tied to a chunk they're located in – clients subscribed to the chunk automatically get updates about entities inside.
* There are multiple ways how a client can receive an entity data:
  * As a part of the chunk inside `ACP::Chunk::Entities`.
  * As part of `ACP::EntityWorldChange` (when entity is moving from void, it is automatically serialized and included).
  * As a standalone `ACP::Entity` message generates as a response for `ACP::EntityRequest`.
    * This mechanism is used when a client receives a message about an entity that it doesn't know about yet, for example when the entity moved from outside the client tracked area. In that case, it receives say `ACP::ETCPhysicsMUpdate` with entity handle that doesn't exist on the client, so it throws the message out, but requests the entity using `ACP::Request`.