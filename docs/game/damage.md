# Damage

Damage is basically key-value struct with keys being damage types and values being `DamageAmount` (`float`).

* There's a `DamageType` managed type that contains information about each damage type - currently just name and color.
* The basic idea is that stuff can deal damage to entities and blocks (for example attack action on swords, pickaxes, status effects, poisons, ...) and then the damage gets converted to health reduction or block mining progress.
  * For entities, the `EA_DamageReceived` callback is called. Then, `ETC_Health` handles converting the damage into health reduction.
  * For blocks, the `BA_DamageReceived` callback is called. Then, `BTC_DamageMining` converts the damage into mining progress and eventually the mining progress can result in the block being destroyed (`BTC_MinedDestroy`) and some items being dropped (`BTC_MinedItemDrop`). 
    * These three components are wrapped together in the `BTC_Mining` composite component which we recommend using.
    * The `BTC_MiningComponent` is included automatically for each block (configurable through the `mining` block type yaml config key).
  * There is currently no resistance mechanic implemented. That should definitely be changed in the future.

Some other damage-related components:

* Entities can `ETC_DamageOnHit` (useful for projectiles).
* Status effects can `SETC_DamageOnApply`.

Some damage types (can possibly change):

* `physicalBlunt`, `physicalCutting`, `physicalPiercing`
* `miningSoft`, `miningHard`
* `explosion`, `fire`, `fall`