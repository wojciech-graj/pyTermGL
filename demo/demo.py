import termgl as tgl
from demo_mandelbrot import demo_mandelbrot
from demo_keyboard import demo_keyboard
from demo_star import demo_star
from demo_color import demo_color
from demo_teapot import demo_teapot


def main() -> None:
    tgl.clear_screen()
    console_size = tgl.get_console_size(True)
    print(
        f"TermGL v{tgl.VERSION[0]}.{tgl.VERSION[1]} Demo Utility",
        f"Console size: {console_size[0]}x{console_size[1]}",
        "Select a Demo:",
        "1. Utah Teapot",
        "    Renders a rotating 3D Utah Teapot.",
        "2. Star Polygon",
        "    Renders a star polygon in steps using random colors.",
        "3. Color Palette",
        "    Renders a palette of various text colors and styles.",
        "4. Mandelbrot",
        "    Renders an infinitely zooming-in Mandelbrot set.",
        "5. Realtime Keyboard",
        "    Displays keyboard input in realtime.",
        sep='\n',
        flush=True
    )

    n = int(input())
    if n == 1:
        choice = input("Use lighting? [Y/N]")
        demo_teapot(40, 40, (choice == 'Y' or choice == 'y'))
    elif n == 2:
        demo_star(80, 40, 500)
    elif n == 3:
        demo_color(40, 10)
    elif n == 4:
        demo_mandelbrot(80, 40)
    elif n == 5:
        demo_keyboard(80, 5, 200)
    else:
        raise Exception("Invalid Input.")


if __name__ == "__main__":
    main()
