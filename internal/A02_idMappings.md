# ID mappings

In general, game types and various other things are identified by UIDs – globally unique and persistent strings (resp. `Identifier`s), for example `block.core.stone` or `statusEffect.core.water`.  In some cases however, it is more beneficial to be able to map the types using a non-sparse indexed array – so we need to assign a sequenced identification number (the game is using `uint16` for that).

For this purpose, there is an ID mapping system in place between `Identifier` (UID) and `uint16` (ID). There are many instances of such mappings:

* Game type UID-ID mappings (`block.air <-> 0`, `block.core.stone <-> 15`, `item.core.pickaxe <-> 15`)
* Component type component UID-ID mappings (for example `block.core.door` has components `BustrixBooleanInput <-> 0` and for `StoredBooleanProperty <-> 1`)
* Component type serialize data mapping (some components don't use serialized data, so we keep separate mappings for data serialization indexing, for example `block.core.door` `StoredBooleanProperty <-> 0`)

The mappings have following properties:

* The mappings are persistent for a particular game (different games can have different mappings).
* The ID mappings are sequential.
* The ID mappings can be semi-sparse (for example when we stop using a mod that has `block.core.lantern <-> 18`, the mapping is kept and internally the ID `18` will point to a `null BlockType`)
* The mappings may not be reused (for example when a mod is removed, the ID<->UID mappings are kept for the case that the mod would be added again).

Individual ID maps are handled by the `IDMappingManager` class, `IDMappingManagerManager` then manages all the various mappings.