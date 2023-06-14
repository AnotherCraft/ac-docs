# Crafting

Crafting is a mechanic that allows you to turn items into something else.

* Rules of crafting are defined by the `CraftingRecipe` class and its components.
* Crafting is always performed by an `Actor`.
  * Actors stats can play a role in crafting output (for example item quality based on actors proficiency).
  * Actors are typically players/entities, but say an automatic crafting station can also be an actor (with its own stats).
  * Crafting is usually done through `ActorAction` - the crafting is not instant, but takes some time and requires actors attention (`CraftingArgs::issueAction` vs `CraftingArgs::executeTransaction`).
* Crafting can be performed on a `CraftingStation` (or with `station` set to null if hand crafting).
  * Crafting stations can be required by some recipes.
  * Crafting stations are identified by tags.

* Crafting is put together in `CraftingArgs`.
  * There can be any number of inputs. Inputs can be divided into `channel`s. (say you might want to have separate channel for energy input or something else)
  * There can be additional parameters for the crafting (for example when you're inscribing a text on a sign, the text would be a parameter).

## Crafting transactions

* Crafting transactions are instant and atomic (either they succeed, inputs are consumed and outputs are generated, or nothing happens).
  * The transactions are not implemented as atomic per se - there are multiple stages of performing the transaction, while each of them can fail. The system is however implemented in such way that 

* Usually, crafting is done through crafting action - which is a`ActorAction` wrapped around a crafting transaction – that way, the crafting transaction takes some time to process.
  * During the crafting action, the actor cannot move.
  * During the crafting action, any of the input and output inventories used for crafting can't be manipulated.
    * These are usually dedicated inventories for crafting input and output, so no biggie.
    * However, this could get annoying with automatic crafting stations where say automatically inserting an item to the input inventory would interrupt the crafting action, which would be annoying.
      * Maybe this needs to be reconsidered a bit - for example when something happens, it should just check whether the transaction can still be executed and only fail if not?
      * Or just check that the captured items haven't been moved from the inventories?
* Crafting transactions do not work over inventories mostly – inputs of the transaction are not moved from the source inventory (unless they're consumed, in that case they're destroyed), transaction outputs are created in void and not moved anywhere.
  * There can however be some item movement, for example when inserting module items into modular items.

* Crafting transactions is performed as follows. The crafting can fail at each stage. To make the crafting transaction atomic, a "simulated" execution is performed first to test if the crafting can be performed.
  * It is checked whether the actor can access the crafting station (`CSA_CanAccess`).
  * It is checked whether the crafting station meets the requirements (has the tag required by the recipe, if set).
  * General crafting availability check is performed (`CRA_CanCraft`).
  * Outputs are generated (output items are created, `CRA_GenerateOutputs`).
  * Inputs are processed – consumed (actual destruction of the item is postponed to the end though), moved, inserted, ...  (`CRA_ProcessInputs`)
  * The recipe is finalized (`CRA_Finalize`)
  * Consumed inputs are destroyed.


## Some crafting recipe components

* `CRC_ConsumeSingleItem` consumes a single item from the input (through `CraftingRecipeInput`). This is used for standard crafting inputs.
* `CRC_ModifyItem` moves the input to the output and calls a function over it. This can be useful for repairing items (changes durability), charging items, inscribing text on signs and so on.
* `CRC_ProduceItem` creates items.
* `CRC_RequireStats` requires the crafting actor to have certain stats in order for the recipe to be performable.

#### `CraftingRecipeInput`

`CraftingRecipeInput` is a utility class used for describing/capturing a crafting input. Characteristic properties:

* `channel` the capture is attempted at
* `item `we're trying to capture of type `ItemFilter` – either item UID or item tag UID
* When `capture` is set, the captured item is marked with the provided tag (useful if you want to do something more with the item during crafting – it can be accessed through the capture key in further stages of the crafting)