# Modding API

AnotherCraft conveys a (currently limited) modding API based around **Webassembly** virtual machine (specifically using the Wasmer library).

* Using WASM allows the mods to be theoretically created in any language that supports WASM, however the options were at the time of writing this article significantly limited.

* For now, we've settled on supporting primarily the **AssemblyScript** programming language, because the syntax (similar to TypeScript) is simple enough and because it's possible to create a portable compiler for it.

  * The compiler currently is bundled with the binaries, the package repository is on [github](https://github.com/AnotherCraft/ac-ascompiler).

* The API is far from complete currently, only some basic functionality to provide a proof of concept.

* The API files can be found in `bin/api/assemblyscript/ac`.

* The API can currently be only used in the form of mod api callbacks – some components have properties of type `ModAPIInlineFunction` that accepts the Assemblyscript code. This is further documented in the [yaml page](yaml.md). Some examples where `ModAPIInlineFunction` is used:

  * `ITC_Durability::maxDurability -> float(Item)`
  * `CRC_FinalizeCallback::callback -> void(CraftingResult)`
  * `CraftingRecipe::durationFunction -> float(CraftingResult)`
  * `TreeSaplingConfig::growthParams -> TreeGrowthParams(TreeGrowthParamsArgs)`
  * `ITC_ComputedNumberProperty::value -> float(Item)`
  * `BTC_ComputedBooleanProperty::value -> bool(WorldBlockContext)`

* Some C++ classes have their AssemblyScript equivalents, however they're possible named a bit differently to make the API simpler/more readable:

  | C++ class           | AssemblyScript class |
  | ------------------- | -------------------- |
  | `ItemInstance`      | `Item`               |
  | `WorldBlockContext` | `Block`              |
  | `Actor`             | `Actor`              |

  