import termgl as tgl


def test_new():
    rgb = tgl.RGB(10, 20, 30)
    assert rgb.r == 10
    assert rgb.g == 20
    assert rgb.b == 30
    assert not rgb.flags


def test_new_with_flags():
    flags = tgl.FmtFlag.BOLD | tgl.FmtFlag.UNDERLINE
    rgb = tgl.RGB(10, 20, 30, flags=flags)
    assert rgb.r == 10
    assert rgb.g == 20
    assert rgb.b == 30
    assert rgb.flags == flags


def test_setters():
    flags = tgl.FmtFlag.BOLD
    rgb = tgl.RGB(10, 20, 30)
    rgb.r = 40
    rgb.g = 50
    rgb.b = 60
    rgb.flags = flags
    assert rgb.r == 40
    assert rgb.g == 50
    assert rgb.b == 60
    assert rgb.flags == flags
