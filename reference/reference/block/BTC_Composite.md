# `BTC_Composite`

> **Children:**<br>
> [BTC_BlockShapeBase](component\shape\BTC_BlockShapeBase.md)

Utility base class allowing block components to include other components with them.

The sub-components are configured programatically and are documented as (Composite) properties in this reference. For the following description, let's consider using <strike>BTC_UniformBlockSides</strike> whose base class [BTC_BlockShapeBase](component\shape\BTC_BlockShapeBase.md) has components `collider: BTC_BoxCollider (Composite)` and `attachable: BTC_AllSidesAttachable (Composite)`. In terms of subcomponent configuration in YAML, there are three options:
* By default, the subcomponent scans the configuration space of the master component, using all relevant properties. With the following configuration YAML code, all classes <strike>BTC_UniformBlockSides</strike>, <strike>BTC_UniformBlockSides</strike>, <strike>BTC_BoxCollider</strike>, <strike>BTC_AllSidesAttachable</strike> scan the same configuration space and all take what's relevant to them. So `texture` is used by <strike>BTC_UniformBlockSides</strike> and `friction` is used by `BTC_BoxCollider`.
```YAML
- component: UniformBlockSides
  texture: tex.png
  friction: 20
```
* You can define an explicit configuration space for the individual subcomponents using the subcomponent name. The following example takes the <strike>BTC_BoxCollider</strike> configuration from under the `collider` key, other components have the configuration space shared in the root.
 ```YAML
- component: UniformBlockSides
  texture: tex.png
  collider:
    friction: 20
```
* If you don't want the subcomponent to be used at all, you can set it's corresponding property to `null`. So the following example would create the <strike>BTC_UniformBlockSides</strike> component without the <strike>BTC_BoxCollider</strike> subcomponent.
```YAML
- component: UniformBlockSides
  collider: null
```

