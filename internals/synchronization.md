# Synchronization/locking in AnotherCraft
AnotherCraft engine is designed in such a way so that the game can run on multiple threads. However that requires adhering to some rules.

These are the basic premises:
* There is only one `Game` active on a given thread in a given time. Pointer to it is stored in the `game` thread-local variable.
  * Setting the `game` variable can be done using the `Game.makeCurrent` and `Game.releaseCurrent` functions or preferably by using `CurrentGuard`.
* Each `World` has an access mutex that has to be locked when doing anything with the world.
  * World does not have a thread affiliation, it can be locked in any thread.
  * Multiple worlds can NOT be locked in a single thread simultaneously
    * The only thread/place where multiple worlds can be locked is DelayedExecutor
  * The locking/unlocking is done using the `World.lockAccess` and `World.unlockAccess` functions or preferably using `AccessGuard`.
    * The locking is recursive - you can lock the world multiple times from the same thread. But you have to unlock it corresponding number of times.
  * There can be synchronized worlds – those world share collisions etc and have to have share the locking mutex. In that case, all synchronized worlds are locked at once with a single mutex.

* Objects like entities and inventories are always affiliated with a world. When manipulating with these objects, access to the world the object belongs to must be locked.
  * Objects can change world affiliation.
    * During the world switch, both source and target worlds must be locked.