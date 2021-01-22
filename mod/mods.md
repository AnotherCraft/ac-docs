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
You can define contents in files in the `content/` folder. The files can have any name, but they must have the `.yaml` suffix.

Example file `sampleBlocks.yaml`:
```YAML
blocks:
  - block: block.core.dirt
    components:
      - component: StaticOpacity
    
      - component: UniformBlockShape
        texture: block/dirt.png

  - block: block.core.stone
    components:
      - component: StaticOpacity

      - component: UniformBlockShape
        texture: block/stone.png

  - block: block.core.stainedGlass.red
    components:
      - component: StaticOpacity
        opacity: 2

      - component: UniformBlockShape
        selfOpaque: true
        texture:
          file: block/red_stained_glass.png
          alphaChannel: transparency
```

## Defining blocks
Format of defining blocks can be seen in the example above.
List of block components and their settings can be found in the `api/block/component/` docs directory.