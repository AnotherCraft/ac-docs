# Collisions and physics

Collision checking in AnotherCraft revolves around the `Collider`.

* All collisions are resolved through AABB - axis aligned bounding boxes, which are represented by the `BoundingBoxX` class. The class uses a custom fixed point `Decimal` type to prevent rounding errors and inconsistencies beetween different computers.

* Collision checking is done on both client and server (server being authoritative), everything should match to the last bit (except for situations that the client cannot predict, such as NPC/other players changes in movement, various interactions and such).
* There are two modes of collision processing:
  * Collider-collider collision processing, implemented in `CollisionEntity`. This is used for most block-entity and entity-entity collisions (`ETC_Physics`).
  * Ray-collider processing, implemented in `CollisionRay`. This is used for ray casting (for stuff like determining what the player is pointing at) and in `ETC_RayPhysics` which is useful for projectiles.
    * This should be faster than the collider-collider approach.
* One entity or block can have as many colliders as it wants.
* There are collisions groups and collision masks - each collider has a bitfield representing what group and masks it has. Two colliders collide if `(group1 & mask2) || (group2 & mask1)`.
* The physics resolution is asymmetrical – during collision checking of entity1, it doesn't consider entity2 speed and vice versa.
* Colliders can have callback functions that can be called when an entity hits the collider with a callback (entity own collider callbacks are ignored). A collider can be marked as virtual to not trigger collision reaction but only call the callbacks if a collision entity collides with it.