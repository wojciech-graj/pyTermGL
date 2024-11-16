# TermGL Tutorial

## Getting Started

Most operations require a rendering context (`TGL`). We can construct a context by specifying the width and height in characters - in this case we have 40 columns and 24 rows. The `puts` function is used to print a (byte-)string at given coordinates with a given color. Finally, we have to call `flush` to print the current frame. `clear` is used to clear the frame buffer, so we don't print the last frame next time we call `flush`.

```python
import termgl as tgl

ctx = tgl.TGL(40, 24)
ctx.puts(0, 0, b"Hello World!", tgl.WHITE)
ctx.flush()
ctx.clear(tgl.Buffer.FRAME)
```

## Colors

*See also:* [demo_color](./../demo/demo_color.py), [demo_rgb](./../demo/demo_rgb.py)

TermGL supports both indexed colors and 24 bit RGB. Drawing functions require a `PixFmt` object, which specifies the colors of the foreground character and the background behind it.

```python
idx1 = tgl.Idx(tgl.Color.WHITE)
idx2 = tgl.Idx(tgl.Color.RED, high_intensity=True, flags=tgl.FmtFlag.UNDERLINE)
rgb1 = tgl.RGB(1, 2, 3)
rgb2 = tgl.RGB(1, 2, 3, flags=tgl.FmtFlag.BOLD | tgl.FmtFlag.UNDERLINE)

color1 = tgl.PixFmt()  # black (default)
color2 = tgl.PixFmt(idx1)  # only foreground
color3 = tgl.PixFmt(rgb2, idx2)  # foreground and background
```

For ease-of-use, `PixFmt` objects for indexed foreground colors are provided as `tgl.WHITE`, `tgl.RED`, etc.

## Settings

TermGL has multiple settings that can be changed in the rendering context using the `enable` and `disable` methods.

```python
ctx = tgl.TGL(40, 24)
ctx.enable(tgl.Setting.OUTPUT_BUFFER | tgl.Setting.CULL_FACE)
```

The following settings are available:

- `OUTPUT_BUFFER`: Output buffer allowing for just one print to flush. Much faster on most terminals, but requires a few hundred kilobytes of memory.
- `Z_BUFFER`: Depth buffer.
- `DOUBLE_WIDTH`: Display characters at double their standard widths (Limited support from terminal emulators. Should work on Windows Terminal, XTerm, and Konsole).
- `DOUBLE_CHARS`: Square pixels by printing 2 characters per pixel.
- `PROGRESSIVE`: Over-write previous frame. Eliminates strobing but requires call to `clear_screen` before drawing smaller image and after resizing terminal if terminal size was smaller than frame size.
- `CULL_FACE`: (3D ONLY) Cull specified triangle faces

## Text Rendering

Text rendering can be performed through either the `putchar` or `puts` methods, to print characters and strings respectively.

```python
ctx = tgl.TGL(40, 24)
ctx.putchar(np.array((0, 1, ord('a')), dtype=tgl.Char), tgl.RED)
ctx.putchar(np.array([(0, 2, ord('b')), (0, 3, ord('c'))], dtype=tgl.Char),
            tgl.BLUE)
ctx.puts(0, 0, b"Hello World!", tgl.WHITE)
ctx.flush()
```

## 2D Rendering

*See also:* [demo_mandelbrot](./../demo/demo_mandelbrot.py)

2D rendering can be performed through the `point`, `line`, and `triangle` methods.

Each vertex has `u` and `v` values between 0 and 255 that, for lines and triangles, get interpolated between points. The color of each pixel being drawn is determined by a `PixelShader`, which receives these `u` and `v` values, and calculates the color and character that will be used for that pixel.

You can implement your own `PixelShader`s, but TermGL also provides a `PixelShaderSimple` that uses a constant color and uses characters from a `Gradient`, and a `PixelShaderTexture` that allows for 2D textures to be applied. TermGL provides the `gradient_full` and `gradient_min` gradients, and allows for user-defined `Gradient`s for the `PixelShaderSimple`.

`point` can take either a single `Vert`, or an array to draw multiple points at once. `line` and `triangle` can take either a 1D array of length 2 or 3 respectively, or a 2D array to draw multiples lines or triangles in a single call.

```python
v0 = (
    19,  # x
    1,  # y
    0.0,  # z (depth)
    0,  # u
    0  # v
)
v1 = (1, 11, 0.0, 127, 0)
v2 = (39, 11, 0.0, 0, 127)

shader_trig = tgl.PixelShaderSimple(tgl.WHITE, tgl.gradient_full)
shader_line = tgl.PixelShaderSimple(tgl.RED, tgl.gradient_min)

ctx = tgl.TGL(40, 24)
ctx.triangle(np.array([v0, v1, v2], dtype=tgl.Vert), shader_trig, fill=True)
ctx.line(np.array([[v0, v1], [v1, v2]], dtype=tgl.Vert), shader_line)
shader_line.color = tgl.BLUE
ctx.point(np.array(v2, dtype=tgl.Vert), shader_line)
ctx.flush()
```

## 3D Rendering

*See also:* [demo_teapot](./../demo/demo_teapot.py), [demo_texture](./../demo/demo_texture.py)

3D rendering can be performed through the `triangle_3d` method.

To only draw triangles from one side, you should enable `Setting.CULL_FACE`, and call `cull_face` to specify which faces you wish to cull.

## Mouse, Keyboard, and Utilities

*See also:* [demo_keyboard](./../demo/demo_keyboard.py), [demo_mouse](./../demo/demo_mouse.py)

On Windows and Linux, TermGL provides functionality for reading mouse and keyboard events, and controlling other aspects of the terminal.

`get_console_size` and `set_console_size` are used to manage the size of the console, and `set_window_title` will attempt to set the window's title. If you don't want the user's input to be visible, or when using mouse tracking, you can disable echoing of user input with `set_echo_input`. Mouse tracking can be enabled and disabled with `set_mouse_tracking_enabled`.

Keyboard and mouse input can be read in real time using the `read` function.

Don't forget to re-enable echoing and re-disable mouse tracking when exiting your program.

```python
ctx = tgl.TGL(0, 0)
tgl.set_echo_input(False)
tgl.set_mouse_tracking_enabled(True)

while True:
    keys, mouse_events = tgl.read(1024, count_events=64)
    print(f"{keys!r}, {mouse_events}")
    sleep(0.1)

tgl.set_mouse_tracking_enabled(True)
tgl.set_echo_input(True)
```
