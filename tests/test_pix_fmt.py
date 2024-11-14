import termgl as tgl


def test_new():
    pix_fmt = tgl.PixFmt()
    assert isinstance(pix_fmt.fg, tgl.Idx)
    assert pix_fmt.fg.color == tgl.Color.BLACK
    assert not pix_fmt.fg.high_intensity
    assert not pix_fmt.fg.flags
    assert isinstance(pix_fmt.bkg, tgl.Idx)
    assert pix_fmt.bkg.color == tgl.Color.BLACK
    assert not pix_fmt.bkg.high_intensity
    assert not pix_fmt.bkg.flags


def test_new_full():
    flags_fg = tgl.FmtFlag.BOLD
    flags_bkg = tgl.FmtFlag.BOLD | tgl.FmtFlag.UNDERLINE
    fg = tgl.RGB(10, 20, 30, flags=flags_fg)
    bkg = tgl.Idx(tgl.Color.BLUE, high_intensity=True, flags=flags_bkg)
    pix_fmt = tgl.PixFmt(fg, bkg)
    assert isinstance(pix_fmt.fg, tgl.RGB)
    assert pix_fmt.fg.r == fg.r
    assert pix_fmt.fg.g == fg.g
    assert pix_fmt.fg.b == fg.b
    assert pix_fmt.fg.flags == fg.flags
    assert isinstance(pix_fmt.bkg, tgl.Idx)
    assert pix_fmt.bkg.color == bkg.color
    assert pix_fmt.bkg.high_intensity == bkg.high_intensity
    assert pix_fmt.bkg.flags == bkg.flags
