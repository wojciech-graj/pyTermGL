"""
TermGL v0.1.0, Internal v1.2.1

Cython bindings for TermGL, the terminal-based graphics library.

*tuple[int, int]* **VERSION**
   Major and Minor C TermGL version

*termgl.Gradient* **gradient_min**
   Minimal gradient of length 10

*termgl.Gradient* **gradient_full**
   Full gradient of length 70
"""

from enum import IntFlag
from typing import Callable, Optional, Tuple

from libc.errno cimport errno
from libc.stdint cimport uint8_t, uint16_t
from libc.string cimport memcpy
from libc.stdio cimport fflush, stdout
from cpython.mem cimport PyMem_Malloc, PyMem_Free

cimport ctermgl as tgl
import numpy as np
cimport numpy as np


VERSION = (tgl.TGL_VERSION_MAJOR, tgl.TGL_VERSION_MINOR)


class Setting(IntFlag):
    """
    Settings.
    Can use bitwise combination of all settings.

    * **Z_BUFFER**: depth buffer
    * **DOUBLE_CHARS**: square pixels by printing 2 characters per pixel
    * **CULL_FACE**: cull specified triangle faces in 3D
    * **OUTPUT_BUFFER**: output buffer allowing for just one print statement to flush. Much faster on most terminals
    * **PROGRESSIVE**: over-write previous frame instead of clearing screen. Elmininates strobing but requires call to tgl_clear_screen before drawing smaller image and after resizing terminal if terminal size was smaller than frame size
    """
    Z_BUFFER = tgl.TGL_Z_BUFFER
    DOUBLE_CHARS = tgl.TGL_DOUBLE_CHARS
    CULL_FACE = tgl.TGL_CULL_FACE
    OUTPUT_BUFFER = tgl.TGL_OUTPUT_BUFFER
    PROGRESSIVE = tgl.TGL_PROGRESSIVE


class Buffer(IntFlag):
    """
    Buffers.
    Can use bitwise combination of all buffers as long as they have been enabled. *FRAME_BUFFER* is always enabled.

    * **FRAME_BUFFER**: frame buffer
    * **Z_BUFFER**: depth buffer
    * **OUTPUT_BUFFER**: output buffer allowing for just one print statement to flush. Much faster on most terminals
    """
    FRAME_BUFFER = tgl.TGL_FRAME_BUFFER
    Z_BUFFER = tgl.TGL_Z_BUFFER
    OUTPUT_BUFFER = tgl.TGL_OUTPUT_BUFFER


class Color(IntFlag):
    """
    Colors and Font Modifiers.
    Can use bitwise combination of up to one **Text Color**, up to one **Background Color**, and any **Modifiers**.

    **Text Color**:

    * **BLACK**
    * **RED**
    * **GREEN**
    * **YELLOW**
    * **BLUE**
    * **PURPLE**
    * **CYAN**
    * **WHITE**

    **Background Color**:

    * **BLACK_BKG**
    * **RED_BKG**
    * **GREEN_BKG**
    * **YELLOW_BKG**
    * **BLUE_BKG**
    * **PURPLE_BKG**
    * **CYAN_BKG**
    * **WHITE_BKG**

    **Modifier**:

    * **HIGH_INTENSITY**
    * **HIGH_INTENSITY_BKG**
    * **BOLD**
    * **UNDERLINE**
    """
    BLACK = tgl.TGL_BLACK
    RED = tgl.TGL_RED
    GREEN = tgl.TGL_GREEN
    YELLOW = tgl.TGL_YELLOW
    BLUE = tgl.TGL_BLUE
    PURPLE = tgl.TGL_PURPLE
    CYAN = tgl.TGL_CYAN
    WHITE = tgl.TGL_WHITE

    BLACK_BKG = tgl.TGL_BLACK_BKG
    RED_BKG = tgl.TGL_RED_BKG
    GREEN_BKG = tgl.TGL_GREEN_BKG
    YELLOW_BKG = tgl.TGL_YELLOW_BKG
    BLUE_BKG = tgl.TGL_BLUE_BKG
    PURPLE_BKG = tgl.TGL_PURPLE_BKG
    CYAN_BKG = tgl.TGL_CYAN_BKG
    WHITE_BKG = tgl.TGL_WHITE_BKG

    HIGH_INTENSITY = tgl.TGL_HIGH_INTENSITY
    HIGH_INTENSITY_BKG = tgl.TGL_HIGH_INTENSITY_BKG
    BOLD = tgl.TGL_BOLD
    UNDERLINE = tgl.TGL_UNDERLINE


class Cull(IntFlag):
    """
    Triangle culling options.
    Must use bitwise combination of one **Face** and one **Winding**.

    **Face**:

    * **BACK**
    * **FRONT**

    **Winding**:

    * **CW**
    * **CCW**
    """
    BACK = tgl.TGL_BACK
    FRONT = tgl.TGL_FRONT
    CW = tgl.TGL_CW
    CCW = tgl.TGL_CCW


def clear_screen() -> None:
    """
    clear_screen()

    Clear the sceen.
    """
    tgl.tgl_clear_screen()
    fflush(stdout)


def flush() -> None:
    """
    flush()

    Flush stdout.
    """
    fflush(stdout)


def read(count: int) -> bytes:
    """
    read(count: int)

    Read up to count bytes (characters) from raw terminal input without blocking.

    :param count: maximum number of bytes to read
    :type count: int
    :returns: input from stdin
    :rtype: bytes
    :raises OSError:
    """
    cdef char *buf = <char*>PyMem_Malloc(count + 1)
    cdef long ret = tgl.tglutil_read(buf, count)
    if (ret < 0):
        raise OSError(errno)
    buf[ret] = '\0'
    retval = bytes(buf)
    PyMem_Free(buf)
    return retval


def get_console_size(screen_buffer: bool) -> Tuple[int, int]:
    """
    get_console_size(screen_buffer)

    Get number of console columns and rows.

    :param bool screen_buffer: True for size of screen buffer, False for size of window. On UNIX, value is ignored and assumed True
    :returns: column and row count
    :rtype: tuple[int, int]
    :raises OSError:
    """
    cdef unsigned col
    cdef unsigned row
    cdef int ret = tgl.tglutil_get_console_size(&col, &row, screen_buffer)
    if (ret == -1):
        raise OSError(errno)
    return (col, row)


def set_console_size(col: int, row: int) -> None:
    """
    set_console_size(col, row)

    Set console size.
    Only changes printable area and will not enlarge window if printable area extends beyond window.

    :param int col: number of columns
    :param int row: number of rows
    :raises OSError:
    """
    cdef int ret = tgl.tglutil_set_console_size(col, row)
    if (ret == -1):
        raise OSError(errno)


cdef class Gradient:
    """
    Gradient(grad)

    Create a new character gradient used by drawing functions in TGL.

    :param bytes grad: Bytestring of characters in increasing intensity
    """
    cdef tgl.TGLGradient *_c_gradient
    cdef bint _free_mem
    _grad: bytes

    def __cinit__(self, grad: bytes, skip: bool = False) -> None:
        self._grad = grad
        if skip:
            self._free_mem = False
            return
        self._free_mem = True
        self._c_gradient = <tgl.TGLGradient*>PyMem_Malloc(sizeof(tgl.TGLGradient))
        self._c_gradient.length = len(self._grad)
        self._c_gradient.grad = self._grad

    def __deinit__(self):
        if self._free_mem:
            PyMem_Free(self._c_gradient)

    @property
    def grad(self) -> bytes:
        """
        *Readonly* Gradient string

        :type: bytes
        """
        return self._grad


cdef Gradient __gradient_from_const(const tgl.TGLGradient *gradient):
    cdef Gradient grad = Gradient(bytes(gradient.grad), skip=True)
    grad._c_gradient = gradient
    return grad


gradient_full = __gradient_from_const(&tgl.gradient_full)


gradient_min = __gradient_from_const(&tgl.gradient_min)


cdef class Transform:
    """
    Transform()

    3D Transformation using 4x4 matrices.
    Applied in order: rotation -> scale -> translation.

    :raises MemoryError:
    """
    cdef tgl.TGLTransform *_c_transform
    cdef bint _free_mem
    _rotation: np.ndarray
    _scale: np.ndarray
    _translation: np.ndarray
    _result: np.ndarray

    def __cinit__(self, skip: bool = False) -> None:
        if skip:
            self._free_mem = False
            return
        self._c_transform = <tgl.TGLTransform*>PyMem_Malloc(sizeof(tgl.TGLTransform))
        if (self._c_transform == NULL):
            raise MemoryError(errno)
        self._free_mem = True

        cdef float[:, :] ident = np.ascontiguousarray(np.identity(4, dtype=np.float32))
        memcpy(self._c_transform.rotate, &ident[0][0], sizeof(tgl.TGLMat))
        memcpy(self._c_transform.scale, &ident[0][0], sizeof(tgl.TGLMat))
        memcpy(self._c_transform.translate, &ident[0][0], sizeof(tgl.TGLMat))
        memcpy(self._c_transform.result, &ident[0][0], sizeof(tgl.TGLMat))
        self._gen_views()

    def _gen_views(self) -> None:
        self._rotation = np.asarray(<float[:4, :4]>&self._c_transform.rotate[0][0])
        self._scale = np.asarray(<float[:4, :4]>&self._c_transform.scale[0][0])
        self._translation = np.asarray(<float[:4, :4]>&self._c_transform.translate[0][0])
        self._result = np.asarray(<float[:4, :4]>&self._c_transform.result[0][0])

    def __deinit__(self):
        if self._free_mem:
            PyMem_Free(self._c_transform)

    @property
    def rotation(self) -> np.ndarray:
        """
        Rotation matrix
        :type: numpy.ndarray[dtype=numpy.float32, shape=(4,4)]
        """
        return self._rotation

    @rotation.setter
    def rotation(self, rotation: np.ndarray) -> None:
        cdef float[:, :] view = np.ascontiguousarray(rotation)
        memcpy(self._c_transform.rotate, &view[0][0], sizeof(tgl.TGLMat))

    @property
    def scale(self) -> np.ndarray:
        """
        Scale matrix
        :type: numpy.ndarray[dtype=numpy.float32, shape=(4,4)]
        """
        return self._scale

    @scale.setter
    def scale(self, scale: np.ndarray) -> None:
        cdef float[:, :] view = np.ascontiguousarray(scale)
        memcpy(self._c_transform.scale, &view[0][0], sizeof(tgl.TGLMat))

    @property
    def translation(self) -> np.ndarray:
        """
        Translation matrix
        :type: numpy.ndarray[dtype=numpy.float32, shape=(4,4)]
        """
        return self._translation

    @translation.setter
    def translation(self, translation: np.ndarray) -> None:
        cdef float[:, :] view = np.ascontiguousarray(translation)
        memcpy(self._c_transform.translate, &view[0][0], sizeof(tgl.TGLMat))

    @property
    def result(self) -> np.ndarray:
        """
        *Readonly* Result matrix obtained after multiplying rotation, scale, and translation matrices
        :type: numpy.ndarray[dtype=numpy.float32, shape=(4,4)]
        """
        return self._result

    def calc_rotation(self, x: float, y: float, z: float) -> None:
        """
        calc_rotation(x, y, z)

        Calculate the rotation matrix

        :param float x:
        :param float y:
        :param float z:
        """
        tgl.tgl3d_transform_rotate(self._c_transform, x, y, z)

    def calc_scale(self, x: float, y: float, z: float) -> None:
        """
        calc_scale(x, y, z)

        Calculate the scale matrix

        :param float x:
        :param float y:
        :param float z:
        """
        tgl.tgl3d_transform_scale(self._c_transform, x, y, z)

    def calc_translation(self, x: float, y: float, z: float) -> None:
        """
        calc_translation(x, y, z)

        Calculate the translation matrix

        :param float x:
        :param float y:
        :param float z:
        """
        tgl.tgl3d_transform_translate(self._c_transform, x, y, z)

    def calc_result(self) -> None:
        """
        calc_result()

        Calculate the result matrix based on the translation, scale, and rotation matrices.
        Must be called prior to *apply* or *applya* if any matrices have changed.
        """
        tgl.tgl3d_transform_update(self._c_transform)

    def apply(self, vin: np.ndarray, vout: np.ndarray) -> None:
        """
        apply(vin, vout)

        Apply the result transformation to three points

        :param numpy.ndarray[dtype=numpy.float32, shape=(3,3)] vin:
        :param numpy.ndarray[dtype=numpy.float32, shape=(3,3)] vout:
        """
        cdef float[:, :] viewout = np.ascontiguousarray(vout)
        cdef float[:, :] viewin = np.ascontiguousarray(vin)
        tgl.tgl3d_transform_apply(self._c_transform, &viewin[0][0], &viewout[0][0])

    def applya(self, vin: np.ndarray, vout: np.ndarray, cnt: int) -> None:
        """
        apply(vin, vout, cnt)

        Apply the result transformation to an array of groups of three points

        :param numpy.ndarray[dtype=numpy.float32, shape=(cnt, 3,3)] vin:
        :param numpy.ndarray[dtype=numpy.float32, shape=(cnt, 3,3)] vout:
        :param int cnt:
        """
        cdef float[:, :, :] viewout = np.ascontiguousarray(vout)
        cdef float[:, :, :] viewin = np.ascontiguousarray(vin)
        cdef int i
        for i in range(cnt):
            tgl.tgl3d_transform_apply(self._c_transform, &viewin[i][0][0],
                                      &viewout[i][0][0])

cdef class TGL:
    """
    TGL(width, height, gradient)

    TermGL rendering context.

    :param int width:
    :param int height:
    :param termgl.Gradient gradient:
    :raises MemoryError:
    """
    cdef tgl.TGL *_c_tgl
    _gradient: Gradient
    _transform: Transform
    _intermediate_shader_func: Optional[Callable[np.ndarray, np.ndarray]]

    def __cinit__(self, width: int, height: int, gradient: Gradient) -> None:
        self._gradient = gradient
        self._intermediate_shader_func = None
        self._c_tgl = tgl.tgl_init(width, height, gradient._c_gradient)
        if (self._c_tgl == NULL):
            raise MemoryError(errno)
        cdef int ret = tgl.tgl3d_init(self._c_tgl)
        if (ret == -1):
            raise MemoryError(errno)
        self._transform = Transform(skip=True)
        self._transform._c_transform = tgl.tgl3d_get_transform(self._c_tgl)
        self._transform._gen_views()

    def __deinit__(self) -> None:
        tgl.tgl_delete(self._c_tgl)

    @property
    def gradient(self) -> Gradient:
        """
        *Readonly*

        :type: termgl.Gradient
        """
        return self._gradient

    @property
    def shader(self) -> Optional[Callable[np.ndarray, np.ndarray]]:
        """
        Shader function called during 3D rendering after projection and clipping, and before writing to framebuffer. Takes the triangle's vertices and the vertices' intensities as input, and these values can be changed by the function.

        :type: Callable[numpy.ndarray[dtype=numpy.float32, shape=(3,3)], numpy.ndarray[dtype=numpy.uint8, shape=(3)]] or None
        """
        return self._intermediate_shader_func

    @shader.setter
    def shader(self, shader: Optional[Callable[np.ndarray, np.ndarray]]) -> None:
        self._intermediate_shader_func = shader

    @property
    def transform(self) -> Transform:
        """
        *Readonly* Internal transform applied before perspective projection. Comparable to view matrix.

        :type: termgl.Transform
        """
        return self._transform

    def flush(self) -> None:
        """
        flush()

        Print framebuffer.

        :raises OSError:
        """
        cdef int ret = tgl.tgl_flush(self._c_tgl)
        if (ret == -1):
            raise OSError(errno)

    def clear(self, buffers: Buffer) -> None:
        """
        clear(buffers)

        Clear buffers.

        :param termgl.Buffer buffers:
        """
        tgl.tgl_clear(self._c_tgl, buffers)

    def enable(self, settings: Setting) -> None:
        """
        enable(settings)

        Enable settings.

        :param termgl.Setting settings:
        :raises MemoryError:
        """
        cdef int ret = tgl.tgl_enable(self._c_tgl, settings)
        if (ret == -1):
            raise MemoryError(errno)

    def disable(self, settings: Setting) -> None:
        """
        disable(settings)

        Disable settings.

        :param termgl.Setting settings:
        """
        tgl.tgl_disable(self._c_tgl, settings)

    def putchar(self, x: int, y: int, c: bytes, color: Color) -> None:
        """
        putchar(x, y, c, color)

        Write a characer to the framebuffer.

        :param int x:
        :param int y:
        :param bytes c:
        :param termgl.Color color:
        """
        tgl.tgl_putchar(self._c_tgl, x, y, c[0], color)

    def puts(self, x: int, y: int, c: bytes, color: Color):
        """
        puts(x, y, c, color)

        Write a string to the framebuffer.

        :param int x:
        :param int y:
        :param bytes c:
        :param termgl.Color color:
        """
        tgl.tgl_puts(self._c_tgl, x, y, c + b'\x00', color)

    def point(self, x: int, y: int, z: float, i: int, color: Color) -> None:
        """
        point(x, y, z, i, color)

        Draw a point to the framebuffer.

        :param int x:
        :param int y:
        :param float z: depth
        :param int i: intensity [0..255]
        :param termgl.Color color:
        """
        tgl.tgl_point(self._c_tgl, x, y, z, i, color)

    def line(self, x0: int, y0: int, z0: float, i0: int,
             x1: int, y1: int, z1: float, i1: int, color: Color) -> None:
        """
        line(x0, y0, z0, i0, x1, y1, z1, i1, color)

        Draw a line to the framebuffer.

        :param int x0:
        :param int y0:
        :param float z0: depth
        :param int i0: intensity [0..255]
        :param int x1:
        :param int y1:
        :param float z1: depth
        :param int i1: intensity [0..255]
        :param termgl.Color color:
        """
        tgl.tgl_line(self._c_tgl, x0, y0, z0, i0, x1, y1, z1, i1, color)

    def triangle(self, x0: int, y0: int, z0: float, i0: int,
                 x1: int, y1: int, z1: float, i1: int,
                 x2: int, y2: int, z2: float, i2: int,
                 color: Color, fill: bool = False) -> None:
        """
        triangle(x0, y0, z0, i0, x1, y1, z1, i1, x2, y2, z2, i2, color, fill=False)

        Draw a triangle to the framebuffer.

        :param int x0:
        :param int y0:
        :param float z0: depth
        :param int i0: intensity [0..255]
        :param int x1:
        :param int y1:
        :param float z1: depth
        :param int i1: intensity [0..255]
        :param int x2:
        :param int y2:
        :param float z2: depth
        :param int i2: intensity [0..255]
        :param termgl.Color color:
        :param bool fill:
        """
        if fill:
            tgl.tgl_triangle_fill(self._c_tgl, x0, y0, z0, i0,
                                  x1, y1, z1, i1, x2, y2, z2, i2, color)
        else:
            tgl.tgl_triangle(self._c_tgl, x0, y0, z0, i0,
                             x1, y1, z1, i1, x2, y2, z2, i2, color)

    def camera(self, fov: float, near: float, far: float) -> None:
        """
        camera(fov, near, far)

        Set the perspective projection matrix.

        :param float fov: field of view in radians
        :param float near: near plane distance
        :param float far: far plane distance
        """
        tgl.tgl3d_camera(self._c_tgl, fov, near, far)

    def cull_face(self, cull: Cull) -> None:
        """
        cull_face(cull)

        Set face culling options.

        :param termgl.Cull cull:
        """
        tgl.tgl3d_cull_face(self._c_tgl, cull)

    def triangle3d(self, vertices: np.ndarray, intensity: np.ndarray,
                   color: Color, fill: bool = False) -> None:
        """
        triangle3d(vertices, intensity, color, fill=False)

        Draw a 3D triangle to the framebuffer.

        :param numpy.ndarray[dtype=numpy.float32, shape=(3,3)] vertices:
        :param numpy.ndarray[dtype=numpy.uint8, shape=(3)] intensity:
        :param termgl.Color color:
        :param bool fill:
        """
        cdef tgl.TGLTriangle trig;
        cdef float[:, :] vertices_view = np.ascontiguousarray(vertices)
        cdef uint8_t[:] intensity_view = np.ascontiguousarray(intensity)
        memcpy(trig.vertices, &vertices_view[0][0], sizeof(tgl.TGLVec3) * 3)
        memcpy(trig.intensity, &intensity_view[0], sizeof(uint8_t) * 3)
        tgl.tgl3d_shader(self._c_tgl, &trig, color, fill, <void*>self,
                         &__intermediate_shader)

    def triangle3da(self, vertices: np.ndarray, intensities: np.ndarray,
                    colors: np.ndarray, fill: np.ndarray, cnt: int) -> None:
        """
        triangle3da(vertices, intensities, colors, fill, cnt)

        Draw an array of 3D triangles to the framebuffer.

        :param numpy.ndarray[dtype=numpy.float32, shape=(cnt, 3, 3)] vertices:
        :param numpy.ndarray[dtype=numpy.uint8, shape=(cnt, 3)] intensities:
        :param numpy.ndarray[dtype=numpy.uint16, shape=(cnt)] colors:
        :param numpy.ndarray[dtype=numpy.bool, shape=(cnt)] fill:
        :param int cnt:
        """
        cdef tgl.TGLTriangle trig;
        cdef float[:, :, :] vertices_view = np.ascontiguousarray(vertices)
        cdef uint8_t[:, :] intensities_view = np.ascontiguousarray(intensities)
        cdef int i
        for i in range(cnt):
            memcpy(trig.vertices, &vertices_view[i][0][0],
                   sizeof(tgl.TGLVec3) * 3)
            memcpy(trig.intensity, &intensities_view[i][0], sizeof(uint8_t) * 3)
            tgl.tgl3d_shader(self._c_tgl, &trig, colors[i], fill[i],
                             <void*>self, &__intermediate_shader)


cdef void __intermediate_shader(tgl.TGLTriangle *inp, void *data):
    cdef TGL self = <TGL>data
    cdef float[:, :] vertices_view = inp.vertices
    cdef uint8_t[:] intensity_view = inp.intensity
    if (self._intermediate_shader_func):
        self._intermediate_shader_func(np.asarray(vertices_view),
                                       np.asarray(intensity_view))
