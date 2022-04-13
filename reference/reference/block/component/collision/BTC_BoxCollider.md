# `BTC_BoxCollider`
> **Parent:** [BlockTypeComponent](../BlockTypeComponent.md)<br>

> **Used in:**<br>
> [BTC_BlockShapeBase](../shape/BTC_BlockShapeBase.md)

Gives the block an axis-aligned box-shaped collider.
## Properties
### `friction`
> **Type:** [Vector3F](../../../core/Vector3F.md)<br>
> **Default value:** `30`<br>

Friction the collider applies, separate for each direction.
### `offset`
> **Type:** [Vector3F](../../../core/Vector3F.md)<br>
> **Default value:** `0`<br>

Offset of the box collider from the bottom center.
### `rayCastOnly`
> **Type:** bool<br>
> **Default value:** `false`<br>

If set to true, the collider does not provide physical collision, but only makes the collider pickable by mouse (ray cast) -> the block can be interacted with/damaged through the collider.
### `size`
> **Type:** [Vector3F](../../../core/Vector3F.md)<br>
> **Default value:** `1`<br>

