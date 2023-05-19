# `BTC_Composite`
> **Parent:** [BlockTypeComponent](../BlockTypeComponent.md)<br>

> **Children:**<br>
> [BTC_BlockShapeBase](../shape/BTC_BlockShapeBase.md)

Utility base class allowing block components to include other components with them.

The sub-components are configured programatically and are documented as (Composite) properties in this reference. For the following description, let's consider using [BTC_UniformBlockShape](../shape/BTC_UniformBlockShape.md) whose base class [BTC_BlockShapeBase](../shape/BTC_BlockShapeBase.md) has components `collider: BTC_BoxCollider (Composite)` and `attachable: BTC_AllSidesAttachable (Composite)`. In terms of subcomponent configuration in YAML, there are three options:
* By default, the subcomponent scans the configuration space of the master component, using all relevant properties. With the following configuration YAML code, all classes [BTC_UniformBlockShape](../shape/BTC_UniformBlockShape.md), [BTC_BlockShapeBase](../shape/BTC_BlockShapeBase.md), [BTC_BoxCollider](../collision/BTC_BoxCollider.md), <strike>BTC_AllSidesAttachable</strike> scan the same configuration space and all take what's relevant to them. So `texture` is used by [BTC_UniformBlockShape](../shape/BTC_UniformBlockShape.md) and `contactFriction` is used by `BTC_BoxCollider`.
```YAML
- component: UniformBlockShape
  texture: tex.png
  contactFriction: 20
```
* You can define an explicit configuration space for the individual subcomponents using the subcomponent name. The following example takes the [BTC_BoxCollider](../collision/BTC_BoxCollider.md) configuration from under the `collider` key, other components have the configuration space shared in the root.
```YAML
- component: UniformBlockShape
  texture: tex.png
  collider:
    contactFriction: 20
```
* If you don't want the subcomponent to be used at all, you can set it's corresponding property to `null`. So the following example would create the [BTC_UniformBlockShape](../shape/BTC_UniformBlockShape.md) component without the [BTC_BoxCollider](../collision/BTC_BoxCollider.md) subcomponent.
```YAML
- component: UniformBlockShape
  collider: null
```

