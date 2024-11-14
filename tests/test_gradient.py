import termgl as tgl


def test_new():
    grad = b"TEST"
    gradient = tgl.Gradient(grad)
    assert gradient.grad == grad


def test_const():
    assert tgl.gradient_min.grad == b" .:-=+*#%@"


def test_char():
    assert tgl.gradient_min.char(0) == ord(' ')
    assert tgl.gradient_min.char(127) == ord('=')
    assert tgl.gradient_min.char(255) == ord('@')
