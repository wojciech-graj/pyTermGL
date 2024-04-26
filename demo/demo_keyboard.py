from time import sleep

import termgl as tgl


def demo_keyboard(res_x: int, res_y: int, frametime_ms: int) -> None:
    ctx = tgl.TGL(res_x, res_y, tgl.gradient_min)
    ctx.enable(tgl.Setting.OUTPUT_BUFFER)

    while True:
        inp = tgl.read(15)
        if inp:
            ctx.puts(0, 0, b"Pressed keys: " + inp, tgl.Color.WHITE)
        else:
            ctx.puts(0, 0, b"Pressed keys: NONE", tgl.Color.WHITE)
        ctx.flush()
        ctx.clear(tgl.Buffer.OUTPUT_BUFFER | tgl.Buffer.FRAME_BUFFER)
        sleep(frametime_ms / 1000)
