# YAML

Most of the content in AnotherCraft is defined through yaml files, so this page describes how to use them and what is the general structure of setting up mods and content.

## Mod directory structure

The directory structure is like follows:

* Game root folder
  * `bin_client_XXX`, `bin_server_XXX`, `bin_common_XXX``
  * `api`
  * `data`
    * `cache`
    * `mods`
      * mod name (for example `core`) - you can add your own files with mods
        * `mod.yaml`: mod manifest (the contents are not used anywhere yet, but the file has to be in the folder)
        * `animation`: [animation files](characterModelsAndAnimations.md) - either `.json` graph files created by [AC-Graphed](https://github.com/AnotherCraft/ac-graphed) or `.ts` AssemblyScript files using the `api/assemblyscript/ac/dataflow.ts` API (which basically generates a `json` file).
        * `code`: AssemblyScript code files. The mod api tries to find the `mod.ts` file. Other files are ignored - the `mod.ts` is expected to import them if they're to be used.
        * `content`: `yaml` files defining content.
          * Files prefixed with `_` are skipped.
        * `env`: environment files (define color gradients and parameters for skybox, lighting and such – configurable in UI through the control panel)
        * `lang`: [translation files](../system/localization.md)
          * Files prefixed with `_` are skipped.
        * `model`: [model files](models.md) (`.fbx`, `.obj`, `.scad`)
        * `preset`: presents for the content files (descibed further in this document)
          * Files prefixed with `_` are skipped.
        * `sound`: sounds
        * `texture`: block textures, item icons and such
        * `worldgen`: for [Woglac worldgen files](https://github.com/AnotherCraft/ac-worldgen). The mod loader does not scan the whole directory, it only takes files mentioned in a wordlgen type definition (which happens in the yaml content folder)
    * `game.sqlite`: database with game data – chunks, items, ...
    * `hive.json`: storage for the [hive](../system/hive.md)

###  `mod.yaml` file

Every mod is required to have a `mod.yaml` file in the mod root directory.

File structure is as follows (though the data is not used anywhere yet):

```YAML
uid: mod.(modUID)
name: (human readable mod name)
author: (author)
license: (license)
```

## Content yaml files

The `content` directory in each mod is (recursively) scanned for `.yaml` files (excluding those starting with the `_` prefix). Each file is then read and its contents processed.

* The root node is expected to be an array/sequence.
* Each item in the sequence is expected to be an object.
* Each object defines one content type.
* Each object is expected to contain the `uid` key that contains unique identifier of the content object we're defining.
  * What type of object the yaml object represents is determined by the prefix of the `uid` value. The UID is usually in the form of `objectType.mod.objectIdentifier.thanCanContainDots`, for example `block.core.door `(using camelCase). The accepted prefixes are the following:
    * `sound`
    * `rigAnimation` 
    * `itemTag`
    * `material`
    * `stat` (`ActorStatType`)
    * `damage`
    * `statusEffect`
    * `block`
    * `item`
    * `entity`
    * `recipe` (`CraftingRecipe`)
    * `worldgen`
* Other object fields are used to configure properties of the defined type.
  * The supported properties are not documented officially yet, you can look them up in the source code in the `TypeClass::loadFromConfig` functions.

### Component types

Component game types (such as `BlockType`, `ItemType`, `InventoryType`) read the `components` key and add corresponding components to the type (this is implemented in `ComponentTypeComponent::loadFromConfig`).

* The `component` key expects a sequence-type value.
* Each item of the sequence is expected to be object-type.
* The object is expect to contain the `component` field where the value is the component type. This is same as the class name without the prefix, so example `BTC_UniformBlockShape` would be described as `component: UniformBlockShape `(using PascalCase).
* The object fields are processed by the created component through the `TA_LoadFromConfig` callback (this callback is the same for all component types).

### General rules/concepts of YAML config files

* All keys are camelCase.
* Uknown keys within type/component objects are ignored and do not raise erorrs. Some keys might only be used by server and some by client
* The implementation should allow multiple consecutive calls to `loadFromConfig`, resp. `TA_LoadFromConfig` callbacks to add new config/introduce new components and such. If object keys are not present, don't change them. 

## Preset files

Presets are a way to use the same yaml config codebase in multiple occurences.

* Presets have a dedicated folder `preset` in the mod directory.
* All `.yaml` files inside the folder are scanned (except for those prefixed with `_`).
* The root node is again expected to be a sequence.
* The sequence elements are again expected to be objects.
* There is expected to be a `uid` key in each object, containing the preset UID (beginning with `preset.`).
* Yaml objects for game types then can have the `preset` key in the root object.  If present, the type `loadFromConfig` function gets first called with the contents of the preset passed as an argument. Then a second `loadFromConfig` call is done for the actual object.

## YAML config formats of some classes

* Enum types accept string value names. The comparison is case insensitive, it is recommended to use camelCase though.

* **Vectors** accept either:

  * A single numerical value (in that case all components are set to the  value)
  * A sequence (preferrably in the `[a, b, c]` syntax); if the sequence is smaller than the vector dimensionality, remaining dimensions are set to 0.

* **Bounding boxes** are a bit complicated.
  There are multiple ways how bounding box can be defined:

  * From lo (first argument) and hi (second argument) vectors (the `box` key; default first argument = `0`)
  * From center (first argument) and size (second argument) vector (the `centerSize` key; Default first argument depends on what the bounding box is supposed to be used for. For example it is `[0.5, 0.5, 0.5]` for block colliders but `[0, 0, 0]` for entity colliders)
  * From bottom center (first argument) and size (second argument) (the `bottomCenterSize` key; Default first argument is same as in the previous point but with the Z component always set to `0`)

  If the bounding box value is an object, it looks for the keys mentioned above and if it finds one, parses the value based on that. If the value is not an object, it is parsed as if it was the `box` key value.
  The value is parsed as follows:

  * If the value is a scalar or a 1-size sequence, the first argument  is default and the second argument is the yaml value (all components set to the same value)
    * For example `box: 2`  or `box: [2]` would create a bounding box `lo=[0, 0, 0] hi=[2, 2, 2]`
  * If the value is a 2-size sequence, the first value is the first argument and the second value is the second argument (all components set to the same value)
    * For example `box: [1, 2]` would create a bounding box `lo=[1, 1, 1] hi=[2, 2, 2]`
  * If the value is a 3-size sequence, the first argument is default and the second argument is a vector constructed from the three yaml values
    * For example `centerSize: [1, 0.5, 2]` would create a bounding box `lo=[0, 0.25, -0.5] hi=[1, 0.75, 1.5]` for block colliders or `lo=[-0.5, -0.25, -1] hi=[0.5, 0.25, 1]` for entity colliders
  * If the value is a 6-size sequence, the first argument is constructed from the first three values and the second argument from the second three values.
    * For example `box: [0, 1, 2, 3, 4, 5]` would create a bounding box `lo=[0, 1, 2] hi=[3, 4, 5]`

* **Inline mod api functions** (represented by the `ModAPIInlineFunction` class) accept either:

  * Numerical value if the function expects `float` return type (in this case the value is static and the mod api backend is not used at all)

  * `true`, `false`, `0` or `1` if the function expects `bool` return type (ditto about the staticity)

  * Callback name that that is registered in the `mod.ts` code file with the `::` prefix added. The callback has to be registered through the `ac.registerCallback` function. So for example your `mod.ts` file would contain:
    ```typescript
    export var treeParams_oak = ac.registerCallback((a: ac.TreeGrowthParamsArgs) : ac.TreeGrowthParams => {
    	let r = new ac.TreeGrowthParams();
    	r.sideBranchInvestment = a.depth > 1 ? 0.8 : 0.2;
    	r.growAlongProbability = a.length < 3 ? 1 : 0.95;
    	r.growUpwardsProbability = a.depth > 0 ? 0.2 : 0.95;
    	r.growHorizontallyProbability = 0.95;
    	r.branchHorizontallyProbability = mapClamp(0, 0.7, 2, 8, a.length + a.depth * 2);
    	r.leavesProbability = mapClamp(0, 0.9, 0, 2, a.depth);
    	return r;
    });
    ```

    And you would refer to this function in yaml as:
    ```YAML
    - uid: block.core.sapling.oak
      components:
        - component: DiagonalCrossShape
          texture:
            file: sapling_oak.png
            alphaChannel: alphaTest
    
        - component: TreeSapling
          trunkBlock: block.core.trunk.oak
          leavesBlock: block.core.leaves.oak
          growPoints: 1024
          selfInvestment: 0.5
          growthParams: ::treeParams_oak # Reference to a function inside mod.ts
    ```

  * Inline code straight up included in the yaml. The default paramater names are defined in the `ModABIValueMeta` class template specialization for a given parameter type. For example see how the `value` computed property is defined in the bustrix AND gate:
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
          value: block.booleanProperty("a") && block.booleanProperty("b") # This is an inline AssemblyScript code
          cachingMethod: serverCached
          propertyChangeTriggers: [a, b]
    ```

    * The inline code snippets are compiled as the `bootstrap.ts` file in the mod root directory.

## File lookup context

When referencing resources like textures, models, sounds et cetera in yaml files, the filenames are looked up within a `FileLookupContext` that is defined. File lookup context is basically a list of directories the engine should look into when searching for a specified file.  The lookup contexts depends on what type of resource the modder is currently referencing – textures will be looked up in the `texture` directory within the mode root directory, sounds will be looked up in `sound` and so on.

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
