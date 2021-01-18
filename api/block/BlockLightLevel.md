# `BlockLightLevel`
A four-component vector (of type `UInt8`), representing light level.

The components can have values `0-15` (inclusive). `0` = no light (or totally transparent when used for defining opacity), `15` = full light (or totally opaque).

The components are red, green, blue and daylight.

Daylight has a separate component because it behaves differently:
* The daylight color can change, depending on the daytime, environment, etc.
* The daylight color is also dependent on the angle between the face normal and the sun.
* The daylight is propagated downwards without any decrease (all other components decrease by `1` to all directions, daylight only horizontally).