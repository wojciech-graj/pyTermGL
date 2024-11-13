from time import sleep

import numpy as np

import termgl as tgl

uvs = [
    [
        [
            0,
            0,
        ],
        [
            0,
            255,
        ],
        [
            255,
            0,
        ],
    ],
    [
        [
            0,
            255,
        ],
        [
            255,
            255,
        ],
        [
            255,
            0,
        ],
    ],
]

trigs = np.array([([
    [
        0,
        0,
        0,
    ],
    [
        0,
        1,
        0,
    ],
    [
        1,
        0,
        0,
    ],
], uvs[0], True), ([
    [
        0,
        1,
        0,
    ],
    [
        1,
        1,
        0,
    ],
    [
        1,
        0,
        0,
    ],
], uvs[1], True), ([
    [
        0,
        0,
        0,
    ],
    [
        1,
        0,
        0,
    ],
    [
        0,
        0,
        1,
    ],
], uvs[0], True), ([
    [
        1,
        0,
        0,
    ],
    [
        1,
        0,
        1,
    ],
    [
        0,
        0,
        1,
    ],
], uvs[1], True), ([
    [
        0,
        0,
        0,
    ],
    [
        0,
        0,
        1,
    ],
    [
        0,
        1,
        0,
    ],
], uvs[0], True), ([
    [
        0,
        0,
        1,
    ],
    [
        0,
        1,
        1,
    ],
    [
        0,
        1,
        0,
    ],
], uvs[1], True), ([
    [
        0,
        0,
        1,
    ],
    [
        1,
        0,
        1,
    ],
    [
        0,
        1,
        1,
    ],
], uvs[0], True), ([
    [
        1,
        0,
        1,
    ],
    [
        1,
        1,
        1,
    ],
    [
        0,
        1,
        1,
    ],
], uvs[1], True), ([
    [
        0,
        1,
        0,
    ],
    [
        0,
        1,
        1,
    ],
    [
        1,
        1,
        0,
    ],
], uvs[0], True), ([
    [
        0,
        1,
        1,
    ],
    [
        1,
        1,
        1,
    ],
    [
        1,
        1,
        0,
    ],
], uvs[1], True), ([
    [
        1,
        0,
        0,
    ],
    [
        1,
        1,
        0,
    ],
    [
        1,
        0,
        1,
    ],
], uvs[0], True), ([
    [
        1,
        1,
        0,
    ],
    [
        1,
        1,
        1,
    ],
    [
        1,
        0,
        1,
    ],
], uvs[1], True)],
                 dtype=tgl.Trig3D)

tex = np.array(
    [[
        (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                      flags=tgl.FmtFlag.BOLD))),
        (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                      flags=tgl.FmtFlag.BOLD))),
        (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                      flags=tgl.FmtFlag.BOLD))),
        (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                      flags=tgl.FmtFlag.BOLD))),
        (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                      flags=tgl.FmtFlag.BOLD))),
        (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                      flags=tgl.FmtFlag.BOLD))),
    ],
     [
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord(' '), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('1'),
          tgl.PixFmt(
              tgl.Idx(tgl.Color.RED,
                      flags=tgl.FmtFlag.BOLD | tgl.FmtFlag.UNDERLINE))),
         (ord(' '), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('2'), tgl.PixFmt(tgl.Idx(tgl.Color.GREEN,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
     ],
     [
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('3'),
          tgl.PixFmt(tgl.Idx(tgl.Color.YELLOW, flags=tgl.FmtFlag.BOLD))),
         (ord(' '), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('4'),
          tgl.PixFmt(
              tgl.Idx(tgl.Color.BLUE,
                      flags=tgl.FmtFlag.BOLD | tgl.FmtFlag.UNDERLINE))),
         (ord(' '), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
     ],
     [
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord(' '), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('5'),
          tgl.PixFmt(
              tgl.Idx(tgl.Color.PURPLE,
                      flags=tgl.FmtFlag.BOLD | tgl.FmtFlag.UNDERLINE))),
         (ord(' '), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('6'), tgl.PixFmt(tgl.Idx(tgl.Color.CYAN,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
     ],
     [
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('7'), tgl.PixFmt(tgl.Idx(tgl.Color.GREEN,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord(' '), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('8'),
          tgl.PixFmt(
              tgl.Idx(tgl.Color.RED,
                      flags=tgl.FmtFlag.BOLD | tgl.FmtFlag.UNDERLINE))),
         (ord(' '), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
     ],
     [
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
         (ord('#'), tgl.PixFmt(tgl.Idx(tgl.Color.WHITE,
                                       flags=tgl.FmtFlag.BOLD))),
     ]],
    dtype=tgl.TexturePixel)


def demo_texture(res_x: int, res_y: int) -> None:
    ctx = tgl.TGL(res_x, res_y)
    ctx.cull_face(tgl.Face.BACK, tgl.Winding.CCW)
    ctx.enable(tgl.Setting.DOUBLE_CHARS | tgl.Setting.CULL_FACE
               | tgl.Setting.Z_BUFFER | tgl.Setting.OUTPUT_BUFFER
               | tgl.Setting.PROGRESSIVE)

    camera = np.zeros((4, 4), dtype=np.float32)
    translate = np.zeros((4, 4), dtype=np.float32)
    translate2 = np.zeros((4, 4), dtype=np.float32)
    rotate = np.zeros((4, 4), dtype=np.float32)

    tgl.camera(camera, res_x, res_y, 1.57, 0.1, 10.0)
    tgl.translate(translate, -0.5, -0.5, -0.5)
    tgl.translate(translate2, 0.0, 0.0, 1.3)

    pixel_shader = tgl.PixelShaderTexture(tex)

    dn = 0.02
    n = 0.0

    while True:
        tgl.rotate(rotate, n / 3.0, n, 0.0)
        vertex_shader = tgl.VertexShaderSimple(
            np.matmul(camera,
                      np.matmul(np.matmul(translate2, rotate), translate)))

        ctx.triangle_3d(trigs, vertex_shader, pixel_shader)

        ctx.flush()
        ctx.clear(tgl.Buffer.FRAME_BUFFER | tgl.Buffer.Z_BUFFER
                  | tgl.Buffer.OUTPUT_BUFFER)

        n += dn

        sleep(16 / 1000)

    input()
