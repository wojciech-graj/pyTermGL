import struct
from math import acos

import termgl as tgl
import numpy as np


LIGHT_DIRECTION = np.array([1, 0, 0], dtype=np.float32)
MAG_LIGHT_DIRECTION = np.linalg.norm(LIGHT_DIRECTION)


def intermediate_shader(verts: np.ndarray, intensity: np.ndarray) -> None:
    ab = np.subtract(verts[1], verts[0])
    ac = np.subtract(verts[2], verts[0])

    # Cross product much faster than np.cross
    cp = np.empty(3, dtype=np.float32)
    cp[0] = (ab[1] * ac[2]) - (ab[2] * ac[1])
    cp[1] = (ab[2] * ac[0]) - (ab[0] * ac[2])
    cp[2] = (ab[0] * ac[1]) - (ab[1] * ac[0])

    dp = np.dot(LIGHT_DIRECTION, cp)
    light_mul = ((0.15) if (dp < 0) else
                 (acos(dp / (np.linalg.norm(cp) * MAG_LIGHT_DIRECTION))
                  * -0.31831 + 1.0))
    intensity[0] = intensity[0] * light_mul
    intensity[1] = intensity[1] * light_mul
    intensity[2] = intensity[2] * light_mul


def stl_load(f) -> np.ndarray:
    data = f.read()
    if data[:5] == b'solid':
        raise Exception("Cannot open ASCII STL file")
    num_trigs = struct.unpack('I', data[80:84])[0]
    trigs = np.empty(shape=(num_trigs, 3, 3), dtype=np.float32)
    for i in range(num_trigs):
        verts = struct.unpack("fffffffff", data[96 + 50 * i: 132 + 50 * i])
        trigs[i] = np.reshape(np.asarray(verts, dtype=np.float32), (3, 3))
    return trigs


def demo_teapot(res_x: int, res_y: int, use_shader: bool) -> None:
    ctx = tgl.TGL(res_x, res_y, tgl.gradient_min)
    ctx.cull_face(tgl.Cull.BACK | tgl.Cull.CCW)
    ctx.enable(tgl.Setting.DOUBLE_CHARS | tgl.Setting.CULL_FACE
               | tgl.Setting.Z_BUFFER | tgl.Setting.OUTPUT_BUFFER
               | tgl.Setting.PROGRESSIVE)
    ctx.camera(1.57, 0.1, 5.0)
    if use_shader:
        ctx.shader = intermediate_shader

    # Load triangles
    with open("demo/utah_teapot.stl", "rb") as f:
        trigs = stl_load(f)

    # Edit camera transformations
    camera_t = ctx.transform
    camera_t.calc_scale(1.0, 1.0, 1.0)
    camera_t.calc_rotation(2.1, 0.0, 0.0)
    camera_t.calc_translation(0.0, 0.0, 2.0)
    camera_t.calc_result()

    # Create transformation matrices for object
    obj_t = tgl.Transform()
    obj_t.calc_scale(0.12, 0.12, 0.12)
    obj_t.calc_translation(0.0, 0.0, 0.0)

    dn = 0.02
    n = 0.

    trigs_out = np.empty(trigs.shape, dtype=np.float32)
    intensities = np.full(fill_value=255, dtype=np.uint8,
                          shape=(trigs.shape[0], 3))
    colors = np.full(fill_value=tgl.Color.WHITE,
                     shape=(trigs.shape[0]), dtype=np.uint16)
    fill = np.full(fill_value=True, shape=(trigs.shape[0]), dtype=bool)

    while True:
        # Edit transformation to move objects
        obj_t.calc_rotation(0.0, 0.0, n)
        obj_t.calc_result()

        # Apply transformation and render
        obj_t.applya(trigs, trigs_out, trigs.shape[0])
        ctx.triangle3da(trigs_out, intensities, colors, fill, trigs.shape[0])

        ctx.flush()
        ctx.clear(tgl.Buffer.FRAME_BUFFER | tgl.Buffer.Z_BUFFER
                  | tgl.Buffer.OUTPUT_BUFFER)

        n += dn
