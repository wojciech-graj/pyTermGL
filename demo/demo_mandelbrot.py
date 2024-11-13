import termgl as tgl


def demo_mandelbrot(res_x: int, res_y: int) -> None:
    ctx = tgl.TGL(res_x, res_y)
    ctx.enable(tgl.Setting.OUTPUT_BUFFER | tgl.Setting.PROGRESSIVE)

    fmt = tgl.PixFmt(tgl.Idx(tgl.Color.WHITE, tgl.FmtFlag.BOLD))

    frame_max = 90
    i_max = 255

    init_mid_x = -1.0
    init_mid_y = 0.0
    end_mid_x = -1.31
    end_mid_y = 0.0
    dmid_x = (end_mid_x - init_mid_x) / frame_max
    dmid_y = (end_mid_y - init_mid_y) / frame_max

    init_width = 0.5
    init_height = 0.5
    end_width = 0.12
    end_height = 0.12
    dwidth = (end_width - init_width) / frame_max
    dheight = (end_height - init_height) / frame_max

    mid_x = init_mid_x
    mid_y = init_mid_y
    width = init_width
    height = init_height

    frame = 0
    while True:
        y = mid_y - 0.5 * height
        dx = width / res_x
        dy = height / res_y
        init_x = mid_x - 0.5 * width
        for pix_y in range(res_y):
            x = init_x
            for pix_x in range(res_x):
                ix = 0.
                iy = 0.
                ix2 = 0.
                iy2 = 0.
                i = 0
                while (ix2 + iy2) <= 4.0 and i < i_max:
                    next_ix = ix2 - iy2 + x
                    iy = 2.0 * ix * iy + y
                    ix = next_ix
                    ix2 = ix * ix
                    iy2 = iy * iy
                    i += 1
                if i < i_max:
                    ctx.putchar(pix_x, pix_y,
                                tgl.gradient_full.char(i * 255 // i_max), fmt)
                x += dx
            y += dy

        ctx.flush()
        ctx.clear(tgl.Buffer.FRAME_BUFFER | tgl.Buffer.OUTPUT_BUFFER)

        if frame < frame_max:
            frame += 1
            mid_x += dmid_x
            mid_y += dmid_y
            width += dwidth
            height += dheight
        else:
            frame = 0
            mid_x = init_mid_x
            mid_y = init_mid_y
            width = init_width
            height = init_height
