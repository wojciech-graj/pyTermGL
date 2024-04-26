# TermGL

Cython binding for a terminal-based graphics library for both 2D and 3D graphics.\
Works in all terminals supporting ANSI escape codes.\
Support for Windows and UNIX.\
Realtime input reading from terminal for user-interaction.\
16 Background colors, 16 foreground colors, bold and underline.

## Table of Contents

[Install](https://github.com/wojciech-graj/pyTermGL/blob/master/README.md#Install)\
[Documentation](https://github.com/wojciech-graj/pyTermGL/blob/master/README.md#Documentation)\
[Gallery](https://github.com/wojciech-graj/pyTermGL/blob/master/README.md#Gallery)

## Install

Package can be found on [PyPI](https://pypi.org/project/termgl/) and can be installed using pip:
```
pip install termgl
```

## Documentation

Documentation can be found [here](https://wojciech-graj.github.io/pyTermGL/)

### Basic Example

```
import termgl as tgl

# Create context and enable settings
ctx = tgl.TGL(10, 10, tgl.gradient_min)
ctx.enable(tgl.Setting.OUTPUT_BUFFER)

# Write to the framebuffer
ctx.puts(1, 0, b"Hello,\nWorld!", tgl.Color.WHITE | tgl.Color.BLUE_BKG)
ctx.line(1, 2, 0, 255, 5, 10, 0, 0, tgl.Color.RED)
ctx.triangle(3, 2, 0, 255, 6, 8, 0, 0, 10, 5, 0, 127, tgl.Color.CYAN, fill=True)

# Print
ctx.flush()
```

### Demo

A variety of demos can be found in the ```demo``` directory
To run the demo utility, simply ```python demo```
Available demos and TermGL features used:
1. Utah Teapot\
Renders a rotating 3D Utah Teapot.
	- Backface culling
	- Z buffering
	- Double-width characters
	- 3D camera
	- 3D transformations
	- 3D rendering
	- 3D Shaders
2. Star Polygon\
Renders a star polygon in steps using random colors.
	- Colors
	- Line rendering
3. Color Palette\
Renders a palette of various text colors and styles.
	- Colors & Modifiers
4. Mandelbrot\
Renders an infinitely zooming-in Mandelbrot set.
	- Point rendering
5. Realtime Keyboard\
Displays keyboard input in realtime.
	- Text rendering
	- Realtime keyboard input

## Gallery

![LOGO](https://github.com/wojciech-graj/pyTermGL/blob/master/screenshot/logo.gif)

![CANYON](https://github.com/wojciech-graj/pyTermGL/blob/master/screenshot/canyon.gif)

![TEAPOT](https://github.com/wojciech-graj/pyTermGL/blob/master/screenshot/teapot.gif)
