# TermGL

A terminal-based graphics library for 2D and 3D graphics.

Features:
- Windows & *NIX support
- C99 compliant without external dependencies
- Custom vertex and pixel shaders
- Affine texture mapping
- 24 bit RGB
- Indexed color mode: 16 Background colors, 16 foreground colors, bold and underline
- Non-blocking input from terminal
- Mouse tracking

![CUBE](https://w-graj.net/images/termgl/textures.gif)

## Installation

Package can be found on [PyPI](https://pypi.org/project/termgl/) and can be installed using pip:
```
pip install termgl
```

## Documentation

The best way to learn to use TermGL is to read the tutorial [here](./TUTORIAL.md).

Additionally, documentation of all public members of TermGL can be found [here](https://wojciech-graj.github.io/pyTermGL/).

## Demo

A variety of demos can be found in the `demo` directory. To run the demo utility, simply `python demo`.

Available demos and TermGL features used:
1. Utah Teapot\
Renders a rotating 3D Utah Teapot.
	- Backface culling
	- Z buffering
	- Double-width characters
	- 3D rendering
	- Custom shaders
2. Color Palette\
Renders a palette of various text colors and styles.
	- Colors & Modifiers
3. Mandelbrot\
Renders an infinitely zooming-in Mandelbrot set.
	- Point rendering
4. Realtime Keyboard\
Displays keyboard input in realtime.
	- Text rendering
	- Realtime keyboard input
5. Textured Cube\
Renders a texture-mapped cube.
	- Backface culling
	- Z buffering
	- Double-width characters
	- 3D rendering
	- Shaders
	- Texture mapping
6. RGB\
Renders overlapping red, green, and blue circles.
	- 24 bit RGB
	- Text rendering
7. Mouse\
Displays mouse position and button state.
	- Mouse tracking
	- Text rendering

### Gallery

![LOGO](https://w-graj.net/images/termgl/logo.gif)

![CANYON](https://w-graj.net/images/termgl/canyon.gif)
