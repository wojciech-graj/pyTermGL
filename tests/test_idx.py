import termgl as tgl


def test_new():
    idx = tgl.Idx(tgl.Color.RED)
    assert idx.color == tgl.Color.RED
    assert not idx.high_intensity
    assert not idx.flags


def test_new_full():
    flags = tgl.FmtFlag.BOLD
    idx = tgl.Idx(tgl.Color.BLUE, high_intensity=True, flags=flags)
    assert idx.color == tgl.Color.BLUE
    assert idx.high_intensity
    assert idx.flags == flags


def test_setters():
    flags = tgl.FmtFlag.BOLD | tgl.FmtFlag.UNDERLINE
    idx = tgl.Idx(tgl.Color.RED)
    idx.color = tgl.Color.WHITE
    idx.high_intensity = True
    idx.flags = flags
    assert idx.color == tgl.Color.WHITE
    assert idx.high_intensity
    assert idx.flags == flags
