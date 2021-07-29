# How to configure crafting (with modAPI) in AC
First some basic things about mod loading:
* Mods are located in the `bin/data/mods` folder. Each folder corresponds to one mod.
* Mod loader looks for `mod.ts` (resp. `mod.client.wasm`) in the root or `code` folder.
* Module `bootstrap.ts` is auto-generated from inline expressions in yaml files.
* Code files are automatically compiled on change.
* The game loads all yaml files in the `content` folder (except for those prefixed with `_` - for commenting out).

## Yaml file structure
* Root of the yaml file is a list of various content records.
* Content record is a dictionary. Type of the content record (if it's an item/block/etc definition) is determined by:
  * Either the record has an explicit `type: item` entry (not recommended)
  * Or the record type is inferred from the UID of the record `uid: item.core.test` -> `type = item` (recommended).
* Basically all fields everywhere are optional. Some just don't make sense not to be filled in.

## Defining recipes
* You can look up an example recipe definition in `mods/core/content/craftingteststuff.yaml`.
* `CraftingRecipe` has this fields:
  * `uid`: UID of the recipe in format `recipe.[modID].[yourRecipeID]`
  * `name`: Defaults to `Craft (output item names)`
  * `finalize`: Shorthand to creating a `Recipe.FinalizeCallback` component.
  * `components`: List of components of the recipe (there can be multiple components of the same type).

* Then, these components are available:
  * `ConsumeSingleItem`: Consumes single item from the input (item is destroyed during crafting)
    * `item`: UID of the expected item (`item.xxx`). You can also use item tag (`itemtag.XXX`).
    * `capture`: Used for naming the input, making it accessible under that name through the modAPI (`craftingResult.captured("name")` or `craftingResult["name"]`).
  * `ProduceItems`: Produces items as a crafting output.
    * `item`: UID of the item produced.
    * `count`: How many items are to be produced
    * `capture`: Same as in `ConsumeSingleItem`
  * `FinalizeCallback`: Executes code upon crafting finalization.
    * `callback`: Code executed (inline function/reference)

## Refering to modapi code from yaml
* Some properties are of `InlineFunction` type (currently only `Item.StoredNumberProperty.initValue` and `Recipe.FinalizeCallback.callback` [`recipe.finalize: XXX` is a shorthand]).
* Example of this can be found in `mods/core/content/craftingteststuff.yaml`.
* You can define such values in multiple ways:
  * You can directly write an expression in the yaml: `initValue: 5 + Math.random(3)`. In this case, the expression is auto-compiled inside `bootstrap.ts`.
  * You can reference a callback function in the `mod.ts` file (`::functionName` - prefix the callback name with `::`). In this case, you have to export a callback variable in the `mod.ts` in the following form:
    * `export var functionName = ac.registerCallback([FUNCTION PROTOTYPE] => { your code here });`.
    * `[FUNCTION PROTOTYPE]` depends on the callback type:
      * For `Item.StoredNumberProperty.initValue` it's `() : f32`
      * For `Recipe.FinalizeCallback.callback` it's `(args: ac.CraftingResult)`.

## ModAPI documentation
* `mod.ts` has to contain `export * from "ac/acexport";` (for exporting some ABI stuff)
* It is also recommended to use `import * as ac from "ac";` for importing of all the AnotherCraft sweet sweet API.
* API runtime is in `bin/api/assemblyscript/ac`, there's not much of it currently.

## Invoking the crafting in the game
* Start the game
* Click on "Select" for the appropriate recipe in the crafting window.
* Open inventory (right bottom corner) and move appropriate items on the left side of the crafting GUI.
* Output preview should appear on the right side of the GUI.
* Click on "Craft" to actually produce the output and to consume the input.
* It will crash if you fill up the output inventory :D