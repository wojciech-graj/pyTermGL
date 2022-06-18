import termgl as tgl


def test_gradient():
    grad = b"TEST"
    gradient = tgl.Gradient(grad)
    assert gradient.grad == grad


def test_gradient_full():
    assert (tgl.gradient_full.grad
            == b" .'`^\",:;Il!i><~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$")  # noqa: E501


def test_gradient_min():
    assert tgl.gradient_min.grad == b" .:-=+*#%@"
