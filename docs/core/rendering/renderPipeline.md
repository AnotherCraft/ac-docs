# Rendering pipeline

Read [renderLists.md](renderLists.md) before.

When rendering a frame, the application does as follows:

* Matrices are computed for all views.
* Frustum culling is dispatched on the GPU (`world_render_frustum_culling.cs.glsl` shader; dispatched for each view independently).
  * This shader goes in parallel through all the render records and determines if they're in the view frustum of the given view.
  * The shader also optionally applies per-model animations and transforms (billboarding, item rotation, ...).
  * If occlusion culling is enabled, also decides whether each record should be rendered without checking or with checking.
  * Indirect params for `glMultiDrawArraysIndirect` are generated here.