# `PersistentHandleObject`

`PersistentHandleObject` is a parent class for all objects that want to have a persistent handle.

* Persistent handle is a 64-bit identifier
* The handle is globally unique within a `Game`
* The handle persists for the object even when the object is unloaded/reloaded (game save, server shutdown, ...)
* The handle is never reused.
* Newly created objects get the handle assigned lazily only when it's first needed (usually for serialization purposes). Temporary objects do not need to have the handle assigned.

`PersistentHandleObject`s are managed by `PersistentHandleManager`. The manager keeps track of currently existing persistent objects and assigns new IDs when needed.

* Only server can assign persistent handles and is fully authoritative in this matter.
* The mechanics also keeps track that an object with the same handle is not loaded twice – indication of duplication bug/save game damage.

Then there's the `PersistentHandlePointer` object that is similar to a weak pointer – it keeps the handle and allows obtaining an object from it if it exists.

* The object with a given handle might not exist for these reasons:
  * The handle has not been assigned yet to any object
  * The object with the given handle exists within the game, but is not currently loaded in the client/server memory
  * The object has been destroyed persistently

# `HandleObject`

`HandleObject`s are similar to `PersistentHandleObject`s, but the handles are not persistent and are only used locally within one application run. A single class can derive from both `HandleObject` and `PersistentHandleObject` at the same time.

The purpose of this is to provide a mechanic of weak pointers – say you have a timer callback that you want to execute only if a relevant block isn't destroyed/unloaded/changed during the period. You can store the `HandleObjectPointer` within the timer callback and check for it.

## Some classes using the handle system

| Class                  | `HandleObject` | `PersistentHandleObject` |
| ---------------------- | -------------- | ------------------------ |
| `EntityInstance`       | yes            | yes                      |
| `ItemInstance`         | yes            | yes                      |
| `Inventory`            | yes            | yes                      |
| `Actor`                | yes            | yes                      |
| `ActorAction`          | yes            | yes                      |
| `StatusEffectInstance` | yes            |                          |
| `EventListener`        | yes            |                          |
| `CraftingStation`      | yes            |                          |

