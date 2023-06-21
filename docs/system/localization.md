# How localization works
* Localization is based on (lang key) -> translatable string pair. There's a bunch of macros and conditions that can be used when dealing with localization.
* Mod loader scans the `lang` directory for each mod (recursively), loading every `.yaml` file starting with `XX_`, where `XX` is the language shorthand.

## Language keys
* By default, every item/entity/whatever UID is also used as a language key for given object name.
  * So for example if you define an item with UID `item.core.test`, you should add `item.core.test: Test item` localization entry into your lang file.
  * Same for blocks. When you define a description for a block, it is also used for the item that represents the block.
* Also for items you can use `(itemUid)_description` lang key to add description for your items.

## Translation parameters
* When invoking translation of a given language key, parameters `(Identifier key, TranslatableString value)` can be passed to the translation and utilised in the translation.
* Also different translation result can be selected based on the parameter values.
  * This can be done by extending the language key definition in the translation file. Instead of simple `key: value` record, syntax like this shall be used:

```yaml
langKey:
  {key1: val, key2: val}: Translation string
  {key3: val}: Translation string 2
  key4: Translation string 3
  default: Default translation
```

Here, they `key/val` are conditions that must all apply for a given key to be applied. Parameters specified by `keyX` must have the same value as `val`. Since the parameter values passed with `TranslatableString` are also translatable strings, they have to be translated first; this is executed with no parameters passed to the parameter translation.

If only one key is specified, as with the `key4` example, the variant has one condition, where `key4` must be `1`.

Translations with more contidions are attempted to be applied first. Order of application attempts for translations with the same condition count is not specified.

## Translation key macros

* `perfix@XXX` can be used to group translation keys with the same prefix, for example

  ```YAML
  prefix@actionError.:
    targetTooFar: Target is too far
    noTarget: No target
    needsBlockTarget: Needs block target
  ```

* `wildcard@XXX` can be used as a fallback for keys with a common name pattern. The `*` symbol serves as a wildcard and is captured as `$wildcard_X` variable where `X` is the wildcard index starting from 1. For example:

  ```YAML
  wildcard@stat.*_max: maximum $TR{stat.$wildcard_1}
  ```

## Translation string macros
* `$param` Returns value of a given parameter
* `$param{k1=v1,k2=v2,...}` Returns value of a given parameter, passes given parameters to the parameter `TranslatableString`. If `*` is passed as a list item, passes all parameters from the parent context. If only `key` is specified, without the `= value`, value is set to `1`.
* `$JOIN{param,glue}` Joins array `param` (iterates `param_0`, `param_1` and so on until unexisting param key is reached) with glue `glue`.
* `$TR{key,k=v1,...}` same as `$param{}`, except the param value is parsed from the first argument (thus it can contain wildcards and macros. If `*` is passed as a list item, passes all parameters from the parent context.
* `$PARAMS{expr,...}` processes the inside expression with the passed parameters. If `*` is passed as a list item, passes all parameters from the parent context. So for example `$PARAMS{Test $param2.,param2=3}` would be resolved into `Test 3.`

## General string macros
* `::^` Makes the nearest following letter capitalized (removes whitespaces between the tag and the letter)
* `::NAME:{ content :}` Various styling markup:
  * `footnote`: Unimportant information (makes it small and gray)
  * `positive`: Something good (good stat)
  * `negative`: Something bad (bad stat)

## Translation guidelines
* Item, block, entity names: capitalized (`Iron Block`, `Wooden Axe`, `Zebra`)
* Actor stats, material names: not capitalized (`wood`, `strength`)