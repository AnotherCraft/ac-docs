# `BTC_BlockShapeBase`
> **Parent:** <span style='color: red;'>BTC_Composite</span><br>
> **Components:** <span style='color: red;'>BTC_BoxCollider</span>, <span style='color: red;'>BTC_AllSidesAttachable</span><br>
> **See also:** [BTC_UniformBlockShape](..\..\..\../reference/block/component/shape/BTC_UniformBlockShape.md)<br>

Base class for all block shaped blocks (=the block is a box, six sides, of size 1).
## Properties
### `selfOpaque`: <span style='color: red;'>bool</span>
> **Default value:** `false`<br>

Whether the block is self-opaque. Self-opaque blocks do not render sides that neighbour with the same block type. This has no effect if the block itself is opaque, but if the sides are transparent (or alpha tested), this switch results in inner sides not being rendered. The most common usage is with glass type blocks.
### `interactsWithParticles`: <span style='color: red;'>bool</span>
> **Default value:** `true`<br>

### `setOpacity`: <span style='color: red;'>bool</span>
> **Default value:** `true`<br>

If true (and if the opacity is not set), makes the block fully opaque in terms of light propagation.
