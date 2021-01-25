# `RenderContextTexture`
The `RenderContextTexture` represents a texture that is used for rendering. That includes the actual image and rendering config.

# Defining in YAML
There are two ways to define a texture in YAML. You can either define it as a single literal representing the file name, or you can use a map for adjusting the config and use the `file` key to specify filename.

```YAML
# Only texture without any config
frontTexture: block/log.png

# With config (see RenderContextConfig.md)
sideTexture:
	file: block/log_side.png
	alphaChannel: alphaTest
```