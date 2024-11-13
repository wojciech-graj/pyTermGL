from demo_color import demo_color
from demo_keyboard import demo_keyboard
from demo_mandelbrot import demo_mandelbrot
from demo_mouse import demo_mouse
from demo_rgb import demo_rgb
from demo_teapot import demo_teapot
from demo_texture import demo_texture

import termgl as tgl


def main() -> None:
    tgl.clear_screen()
    console_size = tgl.get_console_size(True)
    print(f"TermGL v{tgl.VERSION[0]}.{tgl.VERSION[1]} Demo Utility",
          f"Console size: {console_size[0]}x{console_size[1]}",
          "Select a Demo:",
          "1. Utah Teapot",
          "    Renders a rotating 3D Utah Teapot.",
          "2. Color Palette",
          "    Renders a palette of indexed text colors and styles.",
          "3. Mandelbrot",
          "    Renders an infinitely zooming-in Mandelbrot set.",
          "4. Realtime Keyboard",
          "    Displays keyboard input in realtime.",
          "5. Textured Cube",
          "    Renders a texture-mapped cube.",
          "6. RGB",
          "    Renders overlapping red, green, and blue circles.",
          "7. Mouse",
          "    Displays mouse position and button state.",
          sep='\n',
          flush=True)

    match int(input()):
        case 1:
            demo_teapot(40, 40)
        case 2:
            demo_color(40, 10)
        case 3:
            demo_mandelbrot(80, 40)
        case 4:
            demo_keyboard(80, 5, 200)
        case 5:
            demo_texture(40, 40)
        case 6:
            demo_rgb(80, 24)
        case 7:
            demo_mouse(80, 40, 10)
        case _:
            raise ValueError("Invalid Input.")


if __name__ == "__main__":
    main()
