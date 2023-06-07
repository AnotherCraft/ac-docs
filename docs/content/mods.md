# Modding AnotherCraft
Mods are folders in the `mods/` folder.
Mod folder structure is as following:
* `mods/` 
  * `modName/`
    * `mod.yaml`
    * `content/`

## The `mod.yaml` file
Every mod is required to have a `mod.yaml` file in the mod root directory.

File structure is as follows:
```YAML
uid: mod.(modUID)
name: (human readable mod name)
author: (author)
license: (license)
```

## Mod contents
You can define contents in files in the `content/` folder. The files can have any name, but they must have the `.yaml` exension.

Respective YAML definition structures are specified in respective classes documentation.

* All **content is defined through YAML configuration files** (bin/data/mods/core/content/*.yaml)

* Blocks, entity, item types are defined by combining and configuring various components, as described in previous sections.

* Some functionality cannot be described just by YAML config - 

  AC employs a modding API

   for this.

  - The api runs on a webassembly, specifically the Wasmer runtime.
  - Because of the webassembly nature, is it theoretically possible to write the mods in any programming language that allows compiling to webassembly.
  - Currently, there are wrappers written for the Assemblyscript language.
    - The language is good enough for basic modding/functionality, but overall it sucks. I’d very much welcome using a different language, but the selection of languages that allow compiling to wasm in a usable manner is quite limited unfortunately (we also ideally need the compiler to be easily portable and distributable with the game).
  - The modding API is very limited currently, however some stuff is already running on it (for example trees parameter calculation)
  - Some YAML fields actually accept inline Assemblyscript code directly in the config file.

## Example files

Let’s take for example a definition of door in yaml:

```yaml
# Define door block type
- uid: block.core.door
	# This is a shortcut for creating the BTC_Mining component
	# Provides translating damage to mining progress, destroying the block when mined,
	# dropping item when mined
  mining:
    miningSoft: 0.2
  components:
		# Defines how the block looks - like a door
		# This component specifically also provides a collider
		# and creates a proxy block above, because the door take two blocks
    - component: DoorShape
			# Block property that determines whether the door should be open or not
      openProperty: isOpen
      texture:
        file: oak_door.png
        alphaChannel: alphaTest

		# Define the isOpen property, make it stored within the block
    - component: StoredBooleanProperty
      name: isOpen

		# It is possible to interact with the block, the interaction is instant
    - component: InstantInteraction

		# Upon interaction, toggle the $isOpen property
    - component: ToggleBooleanPropertyInteractionBehavior
      property: isOpen

		# Whenever the $isOpen property changes, play a sound
    - component: AudioSource
      sound: door.ogg
      propertyChangeTrigger: isOpen

# As a companion for the block type, define an item type that represents the door block
- uid: item.core.door
	# Shortcut that does multiple things:
	# - takes the name from the block name
	# - makes the item icon the image of the block
  # - defines a basic action that builds the block and consumes the item
  block: true
```

Or a bow item:

```yaml
- uid: item.core.bow 
  components:
		# The bow item has a static image, however with three additional visual variants
    - component: StaticImageIcon
      texture: bow_standby.png
			# The equipped render image is mirrored
      flipEquippedRender: true
      variants:
        pulling0: bow_pulling_0.png
        pulling1: bow_pulling_1.png
        pulling2: bow_pulling_2.png

		# Makes the bow chargeProgress (draw progress) property to determine
		# the visual variant of the item
    - component: NumberPropertyVisualVariant
      property: chargeProgress
      equipRenderOnly: true
      records:
        1-33: pulling0
        33-66: pulling1
        66-100: pulling2

		# The bow provides a charging action
		# - you gotta hold the button to charge it
		# - the action discharges/executed upon button release
    - component: ChargingAction
      chargingProgressProperty: chargeProgress
      successAction: shoot
      animation: none
      chargeTime: 1
      successThreshold: 0.2

		# Define chargeProgress property, stored within the block
    - component: StoredNumberProperty
      name: chargeProgress
      showInDescription: false

		# When the charging action succeeds, spawn an arrow
    - component: SpawnEntityActionBehavior
      action: shoot
      entity: entity.core.arrow
      spawnNormalOffset: 0.1
      spawnOrigin: actor
			# This below is an AssemblyScript code inlined in the YAML
      normalSpeed: 40 * item.numberProperty("chargeProgress") * 0.01
      descLangKey: itemComponent.shootActionBehavior_desc

		# Also when shot is fired, consume an arrow
		# that the player is supposed to hold in the other hand.
		# This also prevents the action from being executed
		# if the player is not holding the arrow.
    - component: ConsumeOtherHandItemActionBehavior
      item: item.core.arrow
      action: shoot
```