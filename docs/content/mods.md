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

