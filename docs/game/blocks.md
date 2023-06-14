# Blocks

See [worlds](worlds.md) to read how blocks are stored. The short version:

* 16×16×256 chunks, each chunk can have a different z offset
* 2 bytes of BlockID
* 1 byte of BlockSmallData
* Unlimited BlockBigData – but use small data whenever possible

New blocks can be created using `BA_Init::exect`. Blocks can be destroyed using `BA_Uninit::exec`.

## Referencing blocks

For working with blocks and referencing them, there's the `WorldBlockContext` class that's the main thing used for working with blocks.

* The class can be bound (and rebound) to any (loaded) block in the game.
  * There are multiple `bind` functions,  optimized variants for rebinding to neighbours or other blocks in the chunk.
* The class provides functions to read block type (setting the block type should be done via `BA_Init::exec` in most situations) and access the data.
* There are also other utility functions like getting/setting mining progress, notifying changes (asking for static render, block id upload, light map recalculation, ...)

## Multiplayer synchronization

* The player first receives block information as a part of the `ACP::Chunk` message. At the same time, he also gets subscribed to the chunk and will receive all further updates until `ACP::ChunkUnrequest` is received.
  * In the future, there should also be a mechanism of auto unsubscribing from the server-side (for example when the client gets too far from the chunk) and notifying the client about it.
* Then, further chunk updates are emitted automatically as a part of the respective callbacks. For example:
  * `BA_Init` broadcasts `ACP::BlockInit`
  * `BA_Uninit` broadcasts `ACP::BlockUninit`
  * `BA_SetProperty` broadcasts `ACP::BlockSetProperty`
* Block components can also broadcast their own messages if they want.

## Block properties

Block property system is the go to mechanic that allows adding depth/parametricity to the blocks and wiring different components within a block type to work together.

* Properties are identified by a unique (within a block type) name of type `Identifier`.
* All block property components derive from `BTC_PropertyBase` that provides common functionality and configuration.
* There are various property components ready for use. They are categorized by:
  * Stored value type: boolean, material, number, recipe, string and possibly others in the future
  * Evaluation type:
    * Stored properties are persistently stored within a block
    * Computed properties are not stored, but computed by some function – possibly from other properties or other things
      * Computed properties can be defined using the mod API functions, even inline in the yaml files. You can also use constants, making the properties static.
      * Computed properties can also be cached (`BTC_PropertyBase::CachingMethod`). Caching means that the function is evaluated once upon first query for the value (lazy initialization), then the value is (non-persistently) stored within the block until it is invalidated.
        * `noCaching` makes the function evaluate each time the property value is queried
        * `independentlyCached` makes the property cached on both client and server independently. The function can be executed on both client and server, depending on where the property value is queried.
        * `serverCached` makes the property cached on the server and basically stored on the client. The client then relies on the server to send him the updated values. For this to work, the property value is automatically queried on the server-side when it gets invalidated.
        * There are mechanics that automatically invalidate the value (causing it to be potentially requeried) on certain events – for example `propertyChangeTriggers`.

* Properties can be configured to be displayed in the block description.
* Property values can be queried using `WorldBlockContext::getProperty` and set using `WorldBlockContext::setProperty` (if the property is not read only). These functions are basically wrappers for the `BA_GetProperty` and `BA_SetProperty` callbacks.

### Example of property usage

For the practical example of how properties can be wired together, let's consider a Bustrix and gate. The gate is defined in the yaml as follows:

```YAML
- uid: block.core.bustrixAndGate
  preset: preset.block.core.bustrixGate
  components:
    - component: BustrixBooleanInput
      uid: input_a
      name: a

    - component: BustrixBooleanInput
      uid: input_b
      name: b

    - component: BustrixBooleanOutput
      property: value

    - component: ComputedBooleanProperty
      name: value
      value: block.booleanProperty("a") && block.booleanProperty("b")
      cachingMethod: serverCached
      propertyChangeTriggers: [a, b]
```



* The gate has two bustrix boolean inputs (`a` and `b`) and one bustrix boolean output (`value`), where `value = a && b`.
* The block is defined as follows:
  * Two `BustrixBooleanInput` components (one for each input `a` and `b`) add bustrix input ports to the block and introduce the input values as computed boolean properties of the same name.
  * The `ComputedBooleanProperty` component then defines a computed property representing the output value of the gate, that is computed as a logical and of the `a` and `b` properties (the function body is an AssemblyScript code using the AnotherCraft modding API).
    * The property is `serverCached` because bustrix input properties are server-only.
    * `propertyChangeTriggers` makes sure the output gets recomputed whenever `a` or `b` changes
  * The `BustrixBooleanOutput` then adds the bustrix output port and sets it to the computed `value` property we've defined before.

