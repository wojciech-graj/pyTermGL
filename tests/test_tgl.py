import termgl as tgl


def test_new():
    tgl.TGL(10, 20)


def test_clear():
    ctx = tgl.TGL(10, 20)
    ctx.clear(tgl.Buffer.FRAME)


def test_enable():
    ctx = tgl.TGL(10, 20)
    ctx.enable(tgl.Setting.PROGRESSIVE | tgl.Setting.Z_BUFFER)


def test_disable():
    ctx = tgl.TGL(10, 20)
    ctx.disable(tgl.Setting.PROGRESSIVE | tgl.Setting.Z_BUFFER)


def test_putchar():
    ctx = tgl.TGL(10, 20)
    ctx.putchar(1, 2, ord('c'), tgl.PixFmt())


def test_puts():
    ctx = tgl.TGL(10, 20)
    ctx.puts(1, 2, b"str", tgl.PixFmt())
