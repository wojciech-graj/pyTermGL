import numpy as np

import termgl as tgl


def test_new():
    mat = np.zeros((4, 4), dtype=np.float32)
    shader = tgl.VertexShaderSimple(mat)
    assert shader is not None


def test_new_invalid_shape():
    mat = np.zeros((3, 4), dtype=np.float32)
    try:
        tgl.VertexShaderSimple(mat)
    except ValueError:
        return
    assert False


def test_new_invalid_type():
    mat = np.zeros((4, 4), dtype=np.byte)
    try:
        tgl.VertexShaderSimple(mat)
    except ValueError:
        return
    assert False
