import termgl as tgl

COLORS = (
    tgl.Color.BLACK,
    tgl.Color.RED,
    tgl.Color.GREEN,
    tgl.Color.YELLOW,
    tgl.Color.BLUE,
    tgl.Color.PURPLE,
    tgl.Color.CYAN,
    tgl.Color.WHITE,
)

MODIFIERS = (
    (False, 0),
    (True, 0),
    (False, tgl.FmtFlag.BOLD),
    (True, tgl.FmtFlag.BOLD),
    (False, tgl.FmtFlag.UNDERLINE),
)

TEXT = (
    ord('K'),
    ord('R'),
    ord('G'),
    ord('Y'),
    ord('B'),
    ord('P'),
    ord('C'),
    ord('W'),
)


def demo_color(res_x: int, res_y: int) -> None:
    ctx = tgl.TGL(res_x, res_y)
    ctx.enable(tgl.Setting.OUTPUT_BUFFER)

    white = tgl.PixFmt(tgl.Idx(tgl.Color.WHITE))
    ctx.puts(9, 0, "NONE", white)
    ctx.puts(9, 2, "HIGH_INTENSITY", white)
    ctx.puts(9, 4, "BOLD", white)
    ctx.puts(9, 6, "BOLD + HIGH_INTENSITY", white)
    ctx.puts(9, 8, "UNDERLINE", white)

    for m in range(5):
        y_start = m * 2
        for c in range(8):
            ctx.putchar(
                c, y_start, TEXT[c],
                tgl.PixFmt(
                    tgl.Idx(COLORS[c],
                            high_intensity=MODIFIERS[m][0],
                            flags=MODIFIERS[m][1]),
                    tgl.Idx(tgl.Color.BLACK,
                            high_intensity=MODIFIERS[m][0],
                            flags=MODIFIERS[m][1])))
            ctx.putchar(
                c, y_start + 1, TEXT[c],
                tgl.PixFmt(
                    tgl.Idx(tgl.Color.BLACK,
                            high_intensity=MODIFIERS[m][0],
                            flags=MODIFIERS[m][1]),
                    tgl.Idx(COLORS[c],
                            high_intensity=MODIFIERS[m][0],
                            flags=MODIFIERS[m][1])))

    ctx.flush()

    input()
