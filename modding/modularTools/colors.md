# Modular tool system

## Color palettes for modularTools
For work with different textures/materials AnotherCraft generator uses 
6 colors from default palette defined in **sourcePalette.png** 
with gradient of violet colors from bright to dark.

![sourcePalette.png file](sourcePalette.png)

Default color | Used for
-|-
<font color='#b040d0'> &#x2BC0; </font> | <font color='#b040d0'>  brighter highlight</font>
<font color='#a030b0'> &#x2BC0; </font> | <font color='#a030b0'>  darker highlight</font>
<font color='#8030a0'> &#x2BC0; </font> | <font color='#8030a0'>  brighter material</font>
<font color='#702080'> &#x2BC0; </font> | <font color='#702080'>  darker material</font>
<font color='#602060'> &#x2BC0; </font> | <font color='#602060'>  brighter shadow</font>
<font color='#402050'> &#x2BC0; </font> | <font color='#402050'>  darker shadow</font>

### Example
Let's create new material - wood.
1. Define gradient of 6 wood colors using default palette system - two colors for highlight, two for material itself, and two for shadows, like:

> Wood color | Used for
> -|-
> <font color='#a4775b'> &#x2BC0; </font> | <font color='#a4775b'>  brighter highlight</font>
> <font color='#8b654b'> &#x2BC0; </font> | <font color='#8b654b'>  darker highlight</font>
> <font color='#7e5033'> &#x2BC0; </font> | <font color='#7e5033'>  brighter material</font>
> <font color='#624024'> &#x2BC0; </font> | <font color='#624024'>  darker material</font>
> <font color='#522f18'> &#x2BC0; </font> | <font color='#522f18'>  brighter shadow</font>
> <font color='#452105'> &#x2BC0; </font> | <font color='#452105'>  darker shadow</font>

2. Make a copy of **sourcePalette.png** with these colors, name it **wood_palette.png** and place it into **materials** folder.

3. Create a material texture (.PNG, 32x32 px), name it **wood_tex1.png** and place it into **materials** folder.

As a result, these palette and texture will be used for rendering wood parts of the tool elements.
