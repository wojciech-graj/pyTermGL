from time import sleep

import termgl as tgl


def demo_keyboard(res_x: int, res_y: int, frametime_ms: int) -> None:
    ctx = tgl.TGL(res_x, res_y)
    ctx.enable(tgl.Setting.OUTPUT_BUFFER)
    tgl.set_echo_input(False)

    white = tgl.PixFmt(tgl.Idx(tgl.Color.WHITE))

    while True:
        input_keys = tgl.read(15)[0]
        ctx.puts(0, 0, "Pressed keys: " + input_keys if input_keys else "NONE",
                 white)
        ctx.flush()
        ctx.clear(tgl.Buffer.OUTPUT_BUFFER | tgl.Buffer.FRAME_BUFFER)
        sleep(frametime_ms / 1000)

    tgl.set_echo_input(True)
