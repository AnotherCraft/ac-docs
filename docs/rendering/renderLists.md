# Rendering lists

The rendering is implemented into the Qt Quick rendering model, meaning the GPU api calls are running on a dedicated renderer thread, that is synced with the main thread before each frame (`QQuickWindow::afterSynchronizing`implemented in `mainwindow.cpp`).

* During this sync, the game is locked and API calls are queued to be later executed on the rendering thread in the rendering phase.
* Also during this phase, dynamic render is executed so that dynamically rendered stuff is smooth and updated each frame.
  * Game step is still 25 times a second and entity positions are not updated and collisions not checked. To make movement smooth, the movement is "predicted" from position and speed reported during the last game step (`position + visualSpeed + lastPositionUpdateTime -> visualPosition` inside `EntityInstance` and `EntityInstanace_ClientComponent`)

## Render records

Rendering is done in render records (can be found in `gpurenderlist.h`) – which is basically a mesh with the same texture.

Render records contain/are identified by these data:

* `RenderContextTexture` - contains texture image + configuration how the texture/mesh should be rendered.
  * Examples on the texture config fields (see `RenderContextConfig` for the full list).
    * Tiling (texture wrap), mipmapping, ...
    * Transparency (alpha, alpha test, ...)
    * Face culling
    * Effect shader (hologram effect), vertex animation shader (plants moving in wind)
    * Whether the mesh should also be rendered inside for shadow mapping
  * `RenderContextTexture`s with compatible `RenderContextConfig` are grouped into the same `RenderContext` (and the texture is stored in separate layers of the same 3D texture) - these can then be rendered in one go using `glMultiDrawArraysIndirect`
* Pointer to mesh data (offset in `GPUBufferAtlas`)
* Bounding box (used  for occlusion and frustum culling)
* Transformation matrix + position offset (stored as an extra vector so that we don't get matrix rounding errors in high-value X and Y world positions)
* Affiliation pointer (this is so that the client is able to delete all records that are say used for rendering an entity and add new, updated ones)

Render records can only be added, they cannot be updated. They can be removed through the affiliation pointer, but not individually.

## Render list

There's a single `GPURenderList` instance that stores/manages all the render records. The records are grouped in `GPUSubRenderList`s by the `RenderContext` (derived from the `RenderContextConfig` of `RenderContextTexture`) and `VertexStorageModel` (determines how the mesh data is organized in the memory – various storage models offer different tradeoffs of bytes per vertex vs customizability).

* For example `VertexStorageModel_Q_V8_TS_NP` uses 16 bytes per quad, but only allows 8 decimal values in the XY directions, no decimal values in the Z direction (so the model must be aligned to the voxel grid), no precise texture mapping (only how many texture repeats fit on the quad) and normal preset.
* `T_VF_TF_NF` uses 96 bytes/triangle (so 192 bytes/quad), but allows precise float vertex positioning, texture mapping and normal

While there being a single render list, the scene is rendered multiple times from different views.

* `Standard` - standard screen view
* `StandardAfterCutoff` - some `RenderContextConfig`s can have a cutoff enabled - in that case, records with distance larger than the set cutoff distance are rendered in `StandardAfterCutoff` view (and other are rendered in the `StandardView`). The views can have a different render config, so for example tree leaves have alpha testing disabled in further distances (and the middle section of the leaves is not rendered at all).
  This view has the same view matrix as the `Standard` view.
* `ShadowCoarse/Medium/Fine` - views for rendering shadow maps from the view of the sun, cascading shadow mapping is utilized
  * Shadow views are depth only, no color data. The render configuration can also be different, for example alpha testing can be disabled through `RenderContextConfig::alphaTestDisableInShadowMap`.
