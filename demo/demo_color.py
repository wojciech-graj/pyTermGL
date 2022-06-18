import termgl as tgl


COLORS_FG = (
    tgl.Color.BLACK,
    tgl.Color.RED,
    tgl.Color.GREEN,
    tgl.Color.YELLOW,
    tgl.Color.BLUE,
    tgl.Color.PURPLE,
    tgl.Color.CYAN,
    tgl.Color.WHITE,
)


COLORS_BKG = (
    tgl.Color.BLACK_BKG,
    tgl.Color.RED_BKG,
    tgl.Color.GREEN_BKG,
    tgl.Color.YELLOW_BKG,
    tgl.Color.BLUE_BKG,
    tgl.Color.PURPLE_BKG,
    tgl.Color.CYAN_BKG,
    tgl.Color.WHITE_BKG,
)


MODIFIERS = (
    (0, 0),
    (tgl.Color.HIGH_INTENSITY, tgl.Color.HIGH_INTENSITY_BKG),
    (tgl.Color.BOLD, tgl.Color.BOLD),
    (tgl.Color.BOLD | tgl.Color.HIGH_INTENSITY, tgl.Color.HIGH_INTENSITY_BKG),
    (tgl.Color.UNDERLINE, tgl.Color.UNDERLINE),
)


TEXT = (
    b"K",
    b"R",
    b"G",
    b"Y",
    b"B",
    b"P",
    b"C",
    b"W",
)


def demo_color(res_x: int, res_y: int) -> None:
    ctx = tgl.TGL(res_x, res_y, tgl.gradient_min)
    ctx.enable(tgl.Setting.OUTPUT_BUFFER)

    ctx.puts(9, 0, b"NONE", tgl.Color.WHITE)
    ctx.puts(9, 2, b"HIGH_INTENSITY", tgl.Color.WHITE)
    ctx.puts(9, 4, b"BOLD", tgl.Color.WHITE)
    ctx.puts(9, 6, b"BOLD + HIGH_INTENSITY", tgl.Color.WHITE)
    ctx.puts(9, 8, b"UNDERLINE", tgl.Color.WHITE)

    for m in range(5):
        y_start = m * 2
        ctx.putchar(0, y_start, b'K',
                    tgl.Color.BLACK | tgl.Color.WHITE_BKG | MODIFIERS[m][0])
        ctx.putchar(0, y_start + 1, b'K',
                    tgl.Color.WHITE | tgl.Color.BLACK_BKG | MODIFIERS[m][1])
        for c in range(1, 8):
            ctx.putchar(c, y_start, TEXT[c],
                        COLORS_FG[c] | tgl.Color.BLACK_BKG | MODIFIERS[m][0])
            ctx.putchar(c, y_start + 1, TEXT[c],
                        tgl.Color.BLACK | COLORS_BKG[c] | MODIFIERS[m][1])

    ctx.flush()
