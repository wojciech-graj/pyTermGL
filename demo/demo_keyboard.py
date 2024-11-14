from time import sleep

import termgl as tgl


def demo_keyboard(res_x: int, res_y: int, frametime_ms: int) -> None:
    ctx = tgl.TGL(res_x, res_y)
    ctx.enable(tgl.Setting.OUTPUT_BUFFER)
    tgl.set_echo_input(False)

    while True:
        input_keys = tgl.read(15)[0]
        ctx.puts(0, 0,
                 b"Pressed keys: " + (input_keys if input_keys else b"NONE"),
                 tgl.WHITE)
        ctx.flush()
        ctx.clear(tgl.Buffer.OUTPUT | tgl.Buffer.FRAME)
        sleep(frametime_ms / 1000)

    tgl.set_echo_input(True)
