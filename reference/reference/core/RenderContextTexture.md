# `RenderContextTexture`
> **Parent:** [RenderContextConfig](RenderContextConfig.md)<br>

> **Used in:**<br>
> [BTC_UniformBlockShape](../block/component/shape/BTC_UniformBlockShape.md)

Class representing a texture with defined properties ([RenderContextConfig](RenderContextConfig.md)).

Can be used in to ways:
* Defining the texture through properties, for example:
```YAML
texture:
  file: img.png
  faceCulling: false
```
* Defining inline with default properties, just the file:
```YAML
texture: img.png
```

## Properties
### `config`: [RenderContextConfig](RenderContextConfig.md)

### `texture`: <strike>string</strike>

File/file path of the texture file.
