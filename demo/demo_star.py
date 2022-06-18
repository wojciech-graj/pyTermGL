from math import cos, sin
from random import randint
from time import sleep

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


def demo_star(res_x: int, res_y: int, frametime_ms: int) -> None:
    ctx = tgl.TGL(res_x, res_y, tgl.gradient_min)
    ctx.enable(tgl.Setting.OUTPUT_BUFFER | tgl.Setting.PROGRESSIVE)

    pi2 = 6.28319
    n = 8
    d = 3

    half_res_x = res_x // 2
    half_res_y = res_y // 2

    vert = 0

    while True:
        next_vert = (vert + d) % n

        angle0 = pi2 * vert / n
        angle1 = pi2 * next_vert / n

        x0 = half_res_x + half_res_x * cos(angle0) * 0.9
        x1 = half_res_x + half_res_x * cos(angle1) * 0.9
        y0 = half_res_y + half_res_y * sin(angle0) * 0.9
        y1 = half_res_y + half_res_y * sin(angle1) * 0.9

        i0 = randint(0, 255)
        i1 = randint(0, 255)
        color = COLORS_FG[randint(0, 7)] | COLORS_BKG[randint(0, 7)]

        ctx.line(x0, y0, 0, i0, x1, y1, 0, i1, color)
        ctx.flush()
        vert = next_vert

        if vert == 0:
            ctx.clear(tgl.Buffer.FRAME_BUFFER | tgl.Buffer.OUTPUT_BUFFER)

        sleep(frametime_ms / 1000)
