# `BTC_BlockShapeBase`
> **Parent:** [BTC_Composite](../util/BTC_Composite.md)<br>

> **Children:**<br>
> [BTC_UniformBlockShape](BTC_UniformBlockShape.md)

> **See also:**<br>
> [BTC_UniformBlockShape](BTC_UniformBlockShape.md)

Base class for all block shaped blocks (=the block is a box, six sides, of size 1).
## Properties
### `attachable` (Composite)
> **Type:** <strike>BTC_AllSidesAttachable</strike><br>

### `collider` (Composite)
> **Type:** [BTC_BoxCollider](../collision/BTC_BoxCollider.md)<br>

### `interactsWithParticles`
> **Type:** bool<br>
> **Default value:** `true`<br>

### `selfOpaque`
> **Type:** bool<br>
> **Default value:** `false`<br>

Whether the block is self-opaque. Self-opaque blocks do not render sides that neighbour with the same block type. This has no effect if the block itself is opaque, but if the sides are transparent (or alpha tested), this switch results in inner sides not being rendered. The most common usage is with glass type blocks.
### `setOpacity`
> **Type:** bool<br>
> **Default value:** `true`<br>

If true (and if the opacity is not set), makes the block fully opaque in terms of light propagation.
