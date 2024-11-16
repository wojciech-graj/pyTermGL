import numpy as np

import termgl as tgl


def _rgb_map_circle(dx: int, dy: int) -> int:
    return int(255 - min(255, (dx * dx * 4 + dy * dy)**0.5 * 3))


def demo_rgb(res_x: int, res_y: int) -> None:
    ctx = tgl.TGL(res_x, res_y)
    ctx.enable(tgl.Setting.OUTPUT_BUFFER)

    for y in range(24):
        for x in range(80):
            x_scld = x * 3
            y_scld = y * 10
            fmt = tgl.RGB(_rgb_map_circle(120 - x_scld, 100 - y_scld),
                          _rgb_map_circle(100 - x_scld, 140 - y_scld),
                          _rgb_map_circle(140 - x_scld, 140 - y_scld))
            ctx.putchar(np.array((x, y, ord('.')), dtype=tgl.Char),
                        tgl.PixFmt(fmt, fmt))

    ctx.flush()

    input()
