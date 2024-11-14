from time import sleep

import termgl as tgl


def demo_mouse(res_x: int, res_y: int, frametime_ms: int) -> None:
    ctx = tgl.TGL(res_x, res_y)
    ctx.enable(tgl.Setting.OUTPUT_BUFFER)
    tgl.set_echo_input(False)
    tgl.set_mouse_tracking_enabled(True)

    ctx.puts(0, 0, b"Move the mouse.", tgl.WHITE)
    ctx.flush()
    ctx.clear(tgl.Buffer.OUTPUT | tgl.Buffer.FRAME)

    while True:
        mouse_events = tgl.read(256, count_events=8)[1]
        if mouse_events:
            event = mouse_events[-1]
            ctx.puts(
                0, 0, f"Mouse position: {event.x:02d}, {event.y:02d}".encode(
                    "ascii"), tgl.WHITE)
            match event.button:
                case tgl.MouseButton.RELEASE:
                    action = b"Release"
                case tgl.MouseButton.MOUSE_1:
                    action = b"Left Click"
                case tgl.MouseButton.MOUSE_2:
                    action = b"Right Click"
                case tgl.MouseButton.MOUSE_3:
                    action = b"Middle Click"
                case _:
                    action = b"Unknown"
            ctx.puts(0, 1, b"Latest action: " + action, tgl.WHITE)

            ctx.flush()
            ctx.clear(tgl.Buffer.OUTPUT | tgl.Buffer.FRAME)

        sleep(frametime_ms / 1000)

    tgl.set_mouse_tracking_enabled(True)
    tgl.set_echo_input(True)
