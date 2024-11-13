import struct

import numpy as np

import termgl as tgl

LIGHT_DIRECTION = np.array([1, 0, 0], dtype=np.float32)
MAG_LIGHT_DIRECTION = np.linalg.norm(LIGHT_DIRECTION)


class PixelShader(tgl.PixelShader):
    trig = None

    def pixel_shader(self, u: int, v: int) -> tuple[tgl.PixFmt, int]:
        ab = self.trig["verts"][1] - self.trig["verts"][0]
        ac = self.trig["verts"][2] - self.trig["verts"][0]

        cp = np.empty(3, dtype=np.float32)
        cp[0] = (ab[1] * ac[2]) - (ab[2] * ac[1])
        cp[1] = (ab[2] * ac[0]) - (ab[0] * ac[2])
        cp[2] = (ab[0] * ac[1]) - (ab[1] * ac[0])

        dp = np.dot(LIGHT_DIRECTION, cp)

        light_mul = 0.15 if dp < 0 else np.acos(
            dp / (np.sqrt(cp.dot(cp)) * MAG_LIGHT_DIRECTION)) / -3.14159 + 1.0

        color = tgl.PixFmt(tgl.Idx(tgl.Color.WHITE, flags=tgl.FmtFlag.BOLD))
        c = tgl.gradient_min.char(light_mul * 255)

        return (color, c)


def pixel_shader(u: int, v: int) -> tuple[tgl.PixFmt, int]:
    ab = np.subtract(verts[1], verts[0])
    ac = np.subtract(verts[2], verts[0])

    # Cross product much faster than np.cross
    cp = np.empty(3, dtype=np.float32)
    cp[0] = (ab[1] * ac[2]) - (ab[2] * ac[1])
    cp[1] = (ab[2] * ac[0]) - (ab[0] * ac[2])
    cp[2] = (ab[0] * ac[1]) - (ab[1] * ac[0])

    dp = np.dot(LIGHT_DIRECTION, cp)
    light_mul = ((0.15) if (dp < 0) else
                 (acos(dp /
                       (np.linalg.norm(cp) * MAG_LIGHT_DIRECTION)) * -0.31831 +
                  1.0))
    intensity[0] = intensity[0] * light_mul
    intensity[1] = intensity[1] * light_mul
    intensity[2] = intensity[2] * light_mul


def stl_load(f) -> np.ndarray:
    data = f.read()
    if data[:5] == b'solid':
        raise Exception("Cannot open ASCII STL file")
    num_trigs = struct.unpack('I', data[80:84])[0]
    trigs = np.empty(shape=(num_trigs), dtype=tgl.Trig3D)
    for i in range(num_trigs):
        verts = struct.unpack("fffffffff", data[96 + 50 * i:132 + 50 * i])
        trigs[i]["verts"] = np.reshape(np.asarray(verts, dtype=np.float32),
                                       (3, 3))
        trigs[i]["uv"] = np.array([[0, 0], [255, 0], [0, 255]], dtype=np.uint8)
        trigs[i]["fill"] = True
    return trigs


def demo_teapot(res_x: int, res_y: int) -> None:
    ctx = tgl.TGL(res_x, res_y)
    ctx.cull_face(tgl.Face.BACK, tgl.Winding.CCW)
    ctx.enable(tgl.Setting.DOUBLE_CHARS | tgl.Setting.CULL_FACE
               | tgl.Setting.Z_BUFFER | tgl.Setting.OUTPUT_BUFFER
               | tgl.Setting.PROGRESSIVE)

    camera = np.zeros((4, 4), dtype=np.float32)
    tgl.camera(camera, res_x, res_y, 1.57, 0.1, 5.0)

    # Load triangles
    with open("demo/utah_teapot.stl", "rb") as f:
        trigs = stl_load(f)

    # Edit camera transformations
    camera_scale = np.zeros((4, 4), dtype=np.float32)
    camera_rotate = np.zeros((4, 4), dtype=np.float32)
    camera_translate = np.zeros((4, 4), dtype=np.float32)

    tgl.scale(camera_scale, 1.0, 1.0, 1.0)
    tgl.rotate(camera_rotate, 2.1, 0.0, 0.0)
    tgl.translate(camera_translate, 0.0, 0.0, 2.0)
    camera_t = np.matmul(np.matmul(camera_translate, camera_scale),
                         camera_rotate)

    # Create transformation matrices for object
    obj_scale = np.zeros((4, 4), dtype=np.float32)
    obj_rotate = np.zeros((4, 4), dtype=np.float32)
    obj_translate = np.zeros((4, 4), dtype=np.float32)

    tgl.scale(obj_scale, 0.12, 0.12, 0.12)
    tgl.translate(obj_translate, 0.0, 0.0, 0.0)

    dn = 0.02
    n = 0.0

    while True:
        # Edit transformation to move objects
        tgl.rotate(obj_rotate, 0.0, 0.0, n)
        obj_t = np.matmul(np.matmul(obj_translate, obj_scale), obj_rotate)
        vertex_shader = tgl.VertexShaderSimple(
            np.matmul(camera, np.matmul(camera_t, obj_t)))

        pixel_shader = PixelShader()

        for trig in trigs:
            pixel_shader.trig = trig
            ctx.triangle_3d(trig, vertex_shader, pixel_shader)

        ctx.flush()
        ctx.clear(tgl.Buffer.FRAME_BUFFER | tgl.Buffer.Z_BUFFER
                  | tgl.Buffer.OUTPUT_BUFFER)

        n += dn * 0.5
