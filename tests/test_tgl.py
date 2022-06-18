from random import randint

import termgl as tgl


def test_tgl_new():
    ctx = tgl.TGL(randint(1, 100), randint(1, 100), tgl.gradient_min)
    assert ctx.gradient == tgl.gradient_min
    assert ctx.shader is None
    assert ctx.transform is not None


def test_tgl_set_shader():
    def shader(vin, iin):
        pass

    ctx = tgl.TGL(1, 1, tgl.gradient_min)
    ctx.shader = shader
    assert ctx.shader == shader
