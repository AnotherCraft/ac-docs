# Shaders

AnotherCraft is running on shaders writen in GLSL for OpenGL 4.6. They're represented by the `GPUShader` class.

In AnotherCraft, each `RenderContextConfig` has its own version of shaders that are compiled specifically for the given render configuration. All the shader versions are however defined in a single fileset (`primitive_render(.vs|.fs)?.glsl`)  and differ only by various defines.

Shaders are also dependent on the graphics settings (provided through the Hive) and recompile if settings change.

For the customizability purposes, the `GPUShaderClass` provides some advanced boilerplate functionality over standard shaders.

## Defines

The defines can be specified for the shader instance using the `GPUShader::define` function. The shaders are automatically dynamically recompiled when any of the defines change. You can even set define to a dynamic hive variable and the shader will update when the variable changes.

The defines are injected into the source code as `#define KEY value` right at the beginning of each shader file.

## Includes

Shaders also support the `#include` directive - this is handled in the `GPUShader `class. The include base path is currently always `src/res/shader`, however this is to be changed in the future.

* `#include` directives are flat out replaced by contents of the specified file.
* Nested includes are allowed.
* All included files are included only once – further `#include` requests of the same file are ignored.

## Hive defines and variables

The source code is also scanned for `HIVE_xxx` – if string like this is found, a define is automatically created that links the corresponding hive value. The shader is automatically recompiled if the value changes.

There's also the `HIVEVARF_xxx` pattern, which creates a `uniform float` of the given name and passes the hive value to it. Shader then doesn't need recompilation when the value changes. However using uniforms like this is a bit inefficient so this is intended only for prototyping purposes.

## Shader precompilation

Shaders are distributed in the source code – otherwise we wouldn't be able to change then dynamically. Once they're compiled on the client system however, they are cached (`bin/data/cache/client/shader`) so that they don't have to be compiled again next time.

So if you're having some issues, try deleting the `bin/data/cache` folder.