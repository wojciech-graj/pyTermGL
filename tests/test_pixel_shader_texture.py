import numpy as np

import termgl as tgl


def test_new():
    pixels = np.array([[(ord('a'), tgl.PixFmt()), (ord('b'), tgl.PixFmt())],
                       [(ord('c'), tgl.PixFmt()), (ord('d'), tgl.PixFmt())]],
                      dtype=tgl.TexPix)
    tgl.PixelShaderTexture(pixels)
