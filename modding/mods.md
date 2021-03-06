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

Respective YAML definition structures are specified in respective classes documentation.

Example file `sampleBlocks.yaml`:
```YAML
blocks:
  # block sequence here
	
  - block: block.core.dirt
    components:
      - component: StaticOpacity
    
      - component: UniformBlockShape
        texture: dirt.png

worldgen:
  # worlgen sequence here

  - worldgen: worldgen.core.overworld
    files:
      - worldgen/overworld.woglac
```