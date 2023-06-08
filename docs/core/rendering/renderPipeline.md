# Rendering pipeline

Read [renderLists.md](renderLists.md) before.

When rendering a frame, the application does as follows (implemented in `GpuRenderList::render` function):

1. Matrices are computed for all views.
2. Frustum culling is dispatched on the GPU (`world_render_frustum_culling.cs.glsl` shader; dispatched for each view independently).
   * This shader goes in parallel through all the render records and determines if they're in the view frustum of the given view.
   * The shader also optionally applies per-model animations and transforms (billboarding, item rotation, ...).
   * If occlusion culling is enabled, also decides based on previous frames whether a record is considered visible and should be rendered or if it is considered occluded and should be queried first.
   * Indirect params for `glMultiDrawArraysIndirect` are generated here.
3. Shadow maps are rendered. Occlusion culling is done in a similar matter as described below for standard rendering.
4. Depth prepass for standard opaque render is executed. This run does not run the fragment shader (or in a very limited manner if alpha testing is enabled) and only writes to the depth buffer.
5. Visible (non-occluded) render records are rendered.
   - Fragment shader marks whether any fragment from the record was actually rendered or not (for occlusion evaluation for the next frame).
   - If depth prepass is enabled, only fragments that match the depth buffer are rendered.
   - Shading is executed here in the fragment shader.
6. Sequentially render transparent rendering layers.
   - Transparency is implemented as order-independent depth peeling - each transparency render pass renders one layer of transparent objects behind the previous one.
   - For second and further layers, additional second near depth test is executed  – fragments that are closer or equal to depth of the previous depth peel are skipped, so that we end up with different transparent layers.
   - Each layer is rendered into a separate framebuffer object.
7. Occlusion query is run - bounding boxes of occluded render records are fragmented(not written anywhere, just ran through fragment shader), flagging records whose bounding boxes are at least partially visible.
8. (optionally) if post occlusion check rendering is enabled (in settings), opaque occluded render records that passed the occlusion query (their bounding boxes were at least partially visible) are rendered.
   - If the option is disabled, those records will not be rendered right away, but in the next frame. This potentially causes slight rendering artifacts when rotating the camera fast (and in some other situations), but it's not that noticeable.
9. Post processing effects are executed (`PostProcessingManager`).
   1. `PPE_Resolve` The image is composed. Resolve multisampling and depth peeling into a single depth and color texture.
   2. `PPE_HideTJunctions` T junctions are hidden. Because of the mesh optimization, T junctions happen and cause visual artifacts. This shader attempts to patch up the small holes that are produced.
   3. `PPE_Atmosphere`
   4. `PPE_Clouds`
   5. `PPE_VolumetricFog`
   6. `PPE_CameraEnvironment` (under water effects)
   7. `PPE_Skybox`
   8. `PPE_Bloom`