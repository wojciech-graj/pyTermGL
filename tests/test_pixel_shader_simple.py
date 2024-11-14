import termgl as tgl


def test_new():
    pix_fmt = tgl.PixFmt()
    tgl.PixelShaderSimple(pix_fmt, tgl.gradient_min)
