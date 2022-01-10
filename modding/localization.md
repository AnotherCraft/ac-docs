# How localization works
* Localization is based on (lang key) -> translatable string pair. There's a bunch of macros and conditions that can be used when dealing with localization.
* Mod loader scans the `lang` directory for each mod (recursively), loading every `.yaml` file starting with `XX_`, where `XX` is the language shorthand.

## Language keys
* By default, every item/entity/whatever UID is also used as a language key for given object name.
  * So for example if you define an item with UID `item.core.test`, you should add `item.core.test: Test item` localization entry into your lang file.
* Also for items you can use `(itemUid)_description` lang key to add description for your items.

## Translation parameters
* When invoking translation of a given language key, parameters `(Identifier key, TranslatableString value)` can be passed to the translation and utilised in the translation.
* Also different translation result can be selected based on the parameter values.

## Translation string macros
* `::^` Makes the nearest following letter capitalized (removes whitespaces between the tag and the letter)
* `$param` Returns value of a given parameter
* `$param{k1:v1;k2:v2;...}` Returns value of a given parameter, passes given parameters to the parameter `TranslatableString`. If `*` is passed as a list item, passes all parameters from the parent context.
* `$$JOIN{param;glue;k1:v1;...}` Joins array `param` (iterates `param_0`, `param_1` and so on until unexisting param key is reached) with glue `glue`. Passes parameters same as above