# Character models and animations
* Export in FBX with skeleton
* The animation system is pose based, not animation based (though animations should be supported too eventually)
* For mounting points (like for where you want to hold items, where hats and various accessories should be placed etc), create a separate node within the skeleton and name it `ext:id1,id2,id3`, where `id1,id2,id3` is a comma separated list of identifiers of the mounting points.
  * Mounting points can have multiple identifiers - for example mounting point for weapon/item holding in your hand can be called `left,hand,leftHand`.
  * Multiple nodes can have the same identifiers - for example if your monster has seven legs and you want to put a boot on each of the leg, the legs can share the `leg` and `leftLeg` identifiers for example.
  * Two nodes cannot be named exactly the same. To prevent name collisions, you can add some arbitrary extra identifier for each node.
  * In items `IA_EquippedRender`, the `equipTarget` identifier (which always begin with `equipTarget.`) informs in what way a given item stack is equipped.
    * Items are then free to do any rendering they want, but by default they'll try to render the item on nodes with the same `equipTarget` identifier (for example `equipTarget.heldLeftHand`, `equipTarget.heldRightHand`).

* The system dos not support vertex groups/transforms/armature modifiers. Meshes have to be parented to the bones.
* So in your animation thingy, you mark poses
  * FBX doesn't support timeline markers so the pose marking kinda sucks.
  * Create time markers in Blender (for other editors, you'll have to define the time markers manually) and then export them using this plugin: https://github.com/grow/blender-animation-marker-export . Put the exported file to the same directory as the fbx model and name it `fileName.markers.json`

# Animations

* The FBX rigs can be procedurally animated.

  * You can either use visual graph editor you can find in the `ac-graphed` repository.
    * See `bin/data/mods/core/animation/humanoid_attack.anim.json` for the example.

  * Or you can define the animations in code through Assemblyscript.
    * See `bin/api/assemblyscript/ac/dataflow.ts` for the API.
    * See `bin/data/mods/core/animation/entity/humanoid.anim.ts` for the example.