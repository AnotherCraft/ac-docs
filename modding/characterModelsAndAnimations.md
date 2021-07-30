# Character models and yadi yadi da
* Export in FBX with skeleton
* The animation system is pose based, not animation based (though animations should be supported too eventually)
* For mounting points (like for where you want to hold items, where hats and various accessories should be placed etc), create a separate node within the skeleton and name it `ext:id1,id2,id3`, where `id1,id2,id3` is a comma separated list of identifiers of the mounting points. Mounting points can have multiple identifiers - for example mounting point for weapon/item holding in your hand can be called `left,hand,leftHand`. Multiple nodes can have shared identifiers - for example if your monster has seven legs and you want to put a boot on each of the leg, the legs can share the `leg` and `leftLeg` identifiers for example.
* The system dos not support vertex groups/transforms/armature modifiers. Meshes have to be parented to the bones.
* So in your animation thingy, you mark poses
  * FBX doesn't support timeline markers so the pose marking kinda sucks.
  * Create time markers in Blender (for other editors, you'll have to define the time markers manually) and then export them using this plugin: https://github.com/grow/blender-animation-marker-export . Put the exported file to the same directory as the fbx model and name it `fileName.markers.json`