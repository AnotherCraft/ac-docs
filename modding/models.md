# Models
Anothercraft supports these model formats:
* `.obj` and `.js` files (`Model`, `BTC_ModelShape`)
* `.fbx` files (`CharacterRigTemplate`, `ETC_AnimatedCharacterRig`)

## `.obj` files
AnotherCraft supports standard `.obj` models, with textures, via the `Model` class.

### Texturing `.obj` files
Model textures can be specified directly in the model itself (as exported from standard modelling tools like Blender). Alternatively, you can have a textureless or colored model (for example exported from a CAD) and let the AC client apply the textures on the model.

This can be done by specifying the `textures` associative array in the model YAML. For example:
```YAML
- component: ModelShape
	followHorizontalOrientation: true
	model:
		file: roof.obj
		textureMode: project
		textures:
			default: hay_block_side.png
			blue: oak_planks.png
```
The default/no material has the `default` key. For other material names, you'll probably have to look into the model materials file to see how they're named (depends on what software you use).

The texture can be auto-applied in multiple ways to the model – that is determined by the `textureMode`. Consult `ModelOBJImporterSettings::TextureMode` for available texturing modes.

### Material models
For blocks, the `BTC_MaterialModelShape` component enables a way to use a template-generated material texture instead, using the same priciple as the [Modular tools](modularTools/README.md).

## OpenJSCAD `.js` files
AnotherCraft supports defining models in OpenJSCAD `.js` files. The files are automatically compiled into `.obj` files in the background. See https://github.com/jscad/OpenJSCAD.org#documentation for OpenJSCAD info and documentation.

The compiling to `.obj` files is done using the [JSCAD package](https://github.com/AnotherCraft/ac-jscad) that is shiped with the AC client.

### Developing/preview of the OpenJSCAD files
When creating the JSCAD models, it's of course very beneficial to have a live preview of the model. This can be done using the [openjscad.xyz website](https://openjscad.xyz/). Loading the model up is a bit unintuitive, as the `Load a JSCAD project` works with project directories, not individual files, but you can load the single `.js` model file up by simply drag & dropping it to the window.

To make the model files work both in the online editor and with the OpenJSCAD compiler, the header code should look like this:
```Javascript
let req = (typeof require.main == "undefined") ? require : (r) => require.main.require(r);

const { polygon } = req("@jscad/modeling").primitives;
const { extrudeLinear } = req("@jscad/modeling").extrusions;
const { rotate, translate } = req('@jscad/modeling').transforms;
const { colorize } = req('@jscad/modeling').colors;
```

You can of course adjust the requires according to your needs, the critical part is the `req` function definition.

### Parameters
The models can be made parametric. The `parameters` YAML key is passed as `const params = {...}` object that is prepended at the beginning of the source file.

### Texturing OpenJSCAD models
To do this, simply set the model file to the appropriate `.js` model definition. Because OpenJSCAD does not work with textures, you can use one of the texturing modes the `ModelOBJImporter` provides, as documented in the sections above. You can apply different textures on various parts of the model using OpenJSCAD colouring. The color -> material name translation is a bit unpredictable, so you'll need to always look in the model file to see how the materials are named.

## `.fbx` files
FBX files are currently supported for animated characters. FBX format is used because it allows defining bones and animations.
See [Character models and animations](characterModelsndAnimations.md).