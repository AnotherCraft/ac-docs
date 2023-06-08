# Content classes

Here is a list of the most important content-related classes:

| Type class         | Instance class                             | Component | Notes                                                        |
| ------------------ | ------------------------------------------ | --------- | ------------------------------------------------------------ |
| `BlockType`        | (`WorldBlockContext` rebindable reference) | yes       | Represents voxels                                            |
| `EntityType`       | `EntityInstance`                           | yes       | Stuff in the world that doesn't adhere to the voxel grid - players, NPCs, animals, ... |
| `ItemType`         | `Item`                                     | yes       |                                                              |
| `ItemTag`          |                                            |           | `Identifier` based, useful for organizing/filtering items.   |
| (not typed)        | `Inventory`                                | yes       | Containers for items                                         |
| `CraftingRecipe`   | (not instanced)                            | yes       | Used for transforming items into other items (and some extra stuff) |
| (not typed)        | `CraftingStation`                          | yes       |                                                              |
| (not typed)        | `Actor`                                    |           | Has stats, can perform actions (build blocks, damage other actors, ...). Some entities can be actors. Some blocks can also contain actors (for example automatic crafting stations) |
| `ActorStatType`    | (managed in `ActorStats`)                  |           | Stats for the actors like health, level, stamina, ... Can be modified by status effects, player equipment, ... |
| `StatusEffectType` | `StatusEffectInstance`                     | yes       | Can be applied on actors and modify their stats, deal damage over time or other various behaviors. |
| (not typed)        | `ActorAction`                              |           | Actions that can be performed by actors - for example swing a blade and damage something, build a block, shoot a bow, ... |
| `Material`         |                                            |           |                                                              |
| `DamageType`       |                                            |           |                                                              |
| `RigAnimation`     |                                            |           |                                                              |
| `BustrixWireType`  |                                            |           |                                                              |
| `BustrixBusType`   |                                            |           |                                                              |

## Component types

Most game types (blocks, entities, ...) are component types – their properties are defined by a list of various small components handling various aspects of the types behavior, look and so on.

* Each component has a unique UID for the component type it was created in.
  * The UID can be assigned manually in the yaml config file by using `uid: xxx`.
  * If the UID is not assigned explicitly, it is assigned manually and is based on the component type (for example `BTC_UniformBlockShape`).
  * If the type has multiple components of the same type, their UIDs cannot be assigned automatically and they have to be defined explicitly in the yaml file.
* A composite component based on the `CompositeTypeComponent` can be defined for game types (for example `BTC_Composite`)  - this component can then compose of other subcomponents.

## Callbacks

Most game type component behavior is defined through callbacks. Callback is a function with a prototype of `void anyFunctionName(const CallbackArgsType &args) constOrNot` . The callback type is defined by the function parameter type - for example `BA_Init`, `IA_Description` and so on.

* The callback type is always `const` and contains all arguments necessary inside the function.

* If the callback requires some sort of result/feedback, it is implemented as a non-const pointer inside the callback type. For example:

  ```C++
  struct IA_CanMoveTo : public ItemStackArgs<IA_CanMoveTo> {
  public: // Arguments
  	ItemStack itemStack;
  	Inventory *targetInventory = nullptr;
  	InventorySlotID targetSlot = invalidInventorySlot;
  	InventoryTransactionContext context;
      
  public: // Results
  	TranslatableString *error = nullptr;
  	bool *result = nullptr;
  }
  ```

* Callbacks are registered and managed using `CallbackManager`
  * A callback-enabled class (usually types/type components) can have any amount of callbacks of the same type registered.
* Typically, callbacks are used in component-based content types such as `BlockType/BlockTypeComponent`, `EntityType/EntityTypeComponent` and so on. The functions should be `const`, because they do not modify type types, but work over the instances of the types (except for type inicialization callbacks like `TA_LoadFromConfig` or `TA_Finalize`).
