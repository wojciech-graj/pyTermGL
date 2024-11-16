"""
TermGL v0.2.0, Internal v1.5.0

Cython bindings for TermGL, the terminal-based graphics library.
"""

IF UNAME_SYSNAME == "Linux" or UNAME_SYSNAME == "Windows":
    DEF TERMGLUTIL = 1
ELSE:
    DEF TERMGLUTIL = 0

from dataclasses import dataclass
from enum import IntFlag, IntEnum, CONFORM
from typing import Annotated, Optional

from cpython.mem cimport PyMem_Malloc, PyMem_Free
from libc.errno cimport errno
from libc.stdint cimport uint8_t
from libc.stdio cimport fflush, stdout
from libc.string cimport memcpy

import numpy as np
cimport numpy as np

cimport ctermgl as tgl
IF TERMGLUTIL == 1:
    cimport ctermglutil as tglutil


__all__ = [
    "TERMGL_VERSION",
    "Vert",
    "Trig3D",
    "TexPix",
    "Char",
    "Setting",
    "Buffer",
    "Color",
    "FmtFlag",
    "Face",
    "Winding",
    "MouseButton",
    "Fmt",
    "RGB",
    "Idx",
    "PixFmt",
    "MouseEvent",
    "BLACK",
    "RED",
    "GREEN",
    "YELLOW",
    "BLUE",
    "PURPLE",
    "CYAN",
    "WHITE",
    "clear_screen",
    "flush",
    "read",
    "get_console_size",
    "set_console_size",
    "set_window_title",
    "set_echo_input",
    "set_mouse_tracking_enabled",
    "Gradient",
    "gradient_full",
    "gradient_min",
    "PixelShader",
    "VertexShader",
    "VertexShaderSimple",
    "PixelShaderSimple",
    "PixelShaderTexture",
    "camera",
    "rotate",
    "scale",
    "translate",
    "TGL",
]


TERMGL_VERSION: tuple[int, int] = (tgl.TGL_VERSION_MAJOR, tgl.TGL_VERSION_MINOR)
cdef tgl.TGLVert _vert_tmp
Vert = np.asarray(<tgl.TGLVert[:1]>(&_vert_tmp)).dtype
Trig3D = np.dtype([("verts", np.float32, (3, 3)), ("uv", np.uint8, (3, 2)), ("fill", np.bool_)])
TexPix = np.dtype([("char", np.byte), ("pix_fmt", PixFmt)])
Char = np.dtype([('x', np.intc), ('y', np.intc), ("char", np.byte)])


class Setting(IntFlag, boundary=CONFORM):
    OUTPUT_BUFFER: Annotated[Setting, "Output buffer allowing for just one print to flush. Much faster on most terminals, but requires a few hundred kilobytes of memory."] = tgl.TGL_OUTPUT_BUFFER
    Z_BUFFER: Annotated[Setting, "Depth buffer."] = tgl.TGL_Z_BUFFER
    DOUBLE_WIDTH: Annotated[Setting, "Display characters at double their standard widths (Limited support from terminal emulators. Should work on Windows Terminal, XTerm, and Konsole)."] = tgl.TGL_DOUBLE_WIDTH
    DOUBLE_CHARS: Annotated[Setting, "Square pixels by printing 2 characters per pixel."] = tgl.TGL_DOUBLE_CHARS
    PROGRESSIVE: Annotated[Setting, "Over-write previous frame. Eliminates strobing but requires call to `clear_screen` before drawing smaller image and after resizing terminal if terminal size was smaller than frame size"] = tgl.TGL_PROGRESSIVE
    CULL_FACE: Annotated[Setting, "(3D ONLY) Cull specified triangle faces"] = tgl.TGL_CULL_FACE


class Buffer(IntFlag, boundary=CONFORM):
    FRAME = tgl.TGL_FRAME_BUFFER
    Z = tgl.TGL_Z_BUFFER
    OUTPUT = tgl.TGL_OUTPUT_BUFFER


class Color(IntEnum):
    BLACK = tgl.TGL_BLACK
    RED = tgl.TGL_RED
    GREEN = tgl.TGL_GREEN
    YELLOW = tgl.TGL_YELLOW
    BLUE = tgl.TGL_BLUE
    PURPLE = tgl.TGL_PURPLE
    CYAN = tgl.TGL_CYAN
    WHITE = tgl.TGL_WHITE


class FmtFlag(IntFlag, boundary=CONFORM):
    BOLD = tgl.TGL_BOLD
    UNDERLINE = tgl.TGL_UNDERLINE


class Face(IntEnum):
    BACK = tgl.TGL_BACK
    FRONT = tgl.TGL_FRONT


class Winding(IntEnum):
    CW = tgl.TGL_CW
    CCW = tgl.TGL_CCW


class MouseButton(IntEnum):
    IF TERMGLUTIL == 0:
        pass
    ELSE:
        UNKNOWN: Annotated[MouseButton, "Assume button state didn't change."] = tglutil.TGL_MOUSE_UNKNOWN
        RELEASE: Annotated[MouseButton, "At least 1 button released. It is unknown which one."] = tglutil.TGL_MOUSE_RELEASE
        MOUSE_1: Annotated[MouseButton, "Left."] = tglutil.TGL_MOUSE_1
        MOUSE_2: Annotated[MouseButton, "Right."] = tglutil.TGL_MOUSE_2
        MOUSE_3: Annotated[MouseButton, "Middle."] = tglutil.TGL_MOUSE_3


cdef class Fmt:
    cdef tgl.TGLFmt _c_fmt

    @staticmethod
    cdef Fmt _from_c(tgl.TGLFmt c_fmt):
        cdef Fmt fmt

        if c_fmt.flags & tgl.TGL_RGB24:
            fmt = RGB.__new__(RGB)
            fmt._c_fmt = c_fmt
            return fmt
        else:
            fmt = Idx.__new__(Idx)
            fmt._c_fmt = c_fmt
            return fmt

    @property
    def flags(self) -> FmtFlag:
        return FmtFlag(self._c_fmt.flags)

    @flags.setter
    def flags(self, flags not None: FmtFlag) -> None:
        raise NotImplementedError


cdef class RGB(Fmt):
    def __cinit__(self) -> None:
        self._c_fmt.flags = tgl.TGL_RGB24

    def __init__(self, uint8_t r, uint8_t g, uint8_t b, flags: Optional[FmtFlag] = None) -> None:
        self._c_fmt.color.rgb.r = r
        self._c_fmt.color.rgb.g = g
        self._c_fmt.color.rgb.b = b
        if flags is not None:
            self._c_fmt.flags |= int(flags)

    @property
    def r(self) -> uint8_t:
        return self._c_fmt.color.rgb.r

    @r.setter
    def r(self, uint8_t r) -> None:
        self._c_fmt.color.rgb.r = r

    @property
    def g(self) -> uint8_t:
        return self._c_fmt.color.rgb.g

    @g.setter
    def g(self, uint8_t g) -> None:
        self._c_fmt.color.rgb.g = g

    @property
    def b(self) -> uint8_t:
        return self._c_fmt.color.rgb.b

    @b.setter
    def b(self, uint8_t b) -> None:
        self._c_fmt.color.rgb.b = b

    @property
    def flags(self) -> FmtFlag:
        return FmtFlag(self._c_fmt.flags)

    @flags.setter
    def flags(self, flags not None: FmtFlag) -> None:
        self._c_fmt.flags = tgl.TGL_RGB24 | int(flags)


cdef class Idx(Fmt):
    def __cinit__(self) -> None:
        self._c_fmt.flags = tgl.TGL_NONE

    def __init__(self, color not None: Color, bint high_intensity = False, flags: Optional[FmtFlag] = None) -> None:
        self._c_fmt.color.indexed = color | tgl.TGL_HIGH_INTENSITY if high_intensity else color
        if flags is not None:
            self._c_fmt.flags |= int(flags)

    cdef tgl.TGLFmt c_fmt(self):
        return self._c_fmt

    @property
    def color(self) -> Color:
        return Color(self._c_fmt.color.indexed & ~tgl.TGL_HIGH_INTENSITY)

    @color.setter
    def color(self, color not None: Color) -> None:
        self._c_fmt.color.indexed &= tgl.TGL_HIGH_INTENSITY
        self._c_fmt.color.indexed |= color

    @property
    def high_intensity(self) -> bool:
        return bool(self._c_fmt.color.indexed & tgl.TGL_HIGH_INTENSITY)

    @high_intensity.setter
    def high_intensity(self, bint high_intensity) -> None:
        if high_intensity:
            self._c_fmt.color.indexed |= tgl.TGL_HIGH_INTENSITY
        else:
            self._c_fmt.color.indexed &= ~tgl.TGL_HIGH_INTENSITY

    @property
    def flags(self) -> FmtFlag:
        return FmtFlag(self._c_fmt.flags)

    @flags.setter
    def flags(self, flags not None: FmtFlag) -> None:
        self._c_fmt.flags = tgl.TGL_NONE | int(flags)

cdef class PixFmt:
    cdef tgl.TGLPixFmt _c_pix_fmt

    def __init__(self, fg: Optional[Fmt] = None, bkg: Optional[Fmt] = None) -> None:
        if fg is not None:
            self._c_pix_fmt.fg = fg._c_fmt
        if bkg is not None:
            self._c_pix_fmt.bkg = bkg._c_fmt

    @property
    def fg(self) -> Fmt:
        return Fmt._from_c(self._c_pix_fmt.fg)

    @fg.setter
    def fg(self, fg not None: Fmt) -> None:
        self._c_pix_fmt.fg = fg._c_fmt

    @property
    def bkg(self) -> Fmt:
        return Fmt._from_c(self._c_pix_fmt.bkg)

    @bkg.setter
    def bkg(self, bkg not None: Fmt) -> None:
        self._c_pix_fmt.bkg = bkg._c_fmt


@dataclass
cdef class MouseEvent:
    button: MouseButton
    mouse_wheel_or_movement: bool
    x: int
    y: int

    IF TERMGLUTIL == 1:
        @staticmethod
        cdef MouseEvent _from_c(tglutil.TGLMouseEvent event):
            return MouseEvent(button = MouseButton(event.button & 0x1f),
                              mouse_wheel_or_movement = bool(event.button & tglutil.TGL_MOUSE_WHEEL_OR_MOVEMENT),
                              x = event.x,
                              y = event.y)

BLACK: PixFmt = PixFmt(Idx(Color.BLACK))
RED: PixFmt = PixFmt(Idx(Color.RED))
GREEN: PixFmt = PixFmt(Idx(Color.GREEN))
YELLOW: PixFmt = PixFmt(Idx(Color.YELLOW))
BLUE: PixFmt = PixFmt(Idx(Color.BLUE))
PURPLE: PixFmt = PixFmt(Idx(Color.PURPLE))
CYAN: PixFmt = PixFmt(Idx(Color.CYAN))
WHITE: PixFmt = PixFmt(Idx(Color.WHITE))


def clear_screen() -> None:
    """Clears the screen."""
    tgl.tgl_clear_screen()
    fflush(stdout)


def flush() -> None:
    fflush(stdout)


def read(size_t count, size_t count_events = 0) -> tuple[bytes, Optional[list[MouseEvent]]]:
    """Reads up to `count` bytes from raw terminal input and optionally reads up to `count_events` mouse events.

    If mouse tracking is enabled but `count_events == 0`, output may contain Xterm control sequences.
    If mouse tracking is enabled, ensure `count >= count_events * 6`.

    :raises ImportError: On operating systems other than Linux or Windows
    """
    IF TERMGLUTIL == 0:
        raise ImportError("TermGLUtil is only available on Linux and Windows systems")
    ELSE:
        cdef char *buf = <char *>PyMem_Malloc(count + 1)
        cdef tglutil.TGLMouseEvent *event_buf = NULL
        if count_events:
            event_buf = <tglutil.TGLMouseEvent *>PyMem_Malloc(sizeof(tglutil.TGLMouseEvent) * count_events)
        cdef size_t count_read_events = 0
        cdef ssize_t ret = tglutil.tglutil_read(buf, count, event_buf, count_events, &count_read_events)
        if ret < 0:
            PyMem_Free(buf)
            PyMem_Free(event_buf)
            raise OSError(errno)

        buf[ret] = b'\0'
        retval = bytes(buf)

        if count_events:
            mouse_events = []
            for i in range(count_read_events):
                mouse_events.append(MouseEvent._from_c(event_buf[i]))
        else:
            mouse_events = None

        PyMem_Free(buf)
        PyMem_Free(event_buf)
        return (retval, mouse_events)


def get_console_size(bint screen_buffer = True) -> tuple[int, int]:
    """Gets number of console columns and rows.

    :param screen_buffer: `True` for size of screen buffer, `False` for size of window. On UNIX, value is ignored and assumed `True`.
    :raises ImportError: On operating systems other than Linux or Windows
    """
    IF TERMGLUTIL == 0:
        raise ImportError("TermGLUtil is only available on Linux and Windows systems")
    ELSE:
        cdef unsigned col
        cdef unsigned row
        cdef int ret = tglutil.tglutil_get_console_size(&col, &row, screen_buffer)
        if ret < 0:
            raise OSError(errno)

        return (col, row)


def set_console_size(unsigned col, unsigned row) -> None:
    """Sets console size.

    Only changes printable area and will not change window size if new size is larger than window

    :raises ImportError: On operating systems other than Linux or Windows
    """
    IF TERMGLUTIL == 0:
        raise ImportError("TermGLUtil is only available on Linux and Windows systems")
    ELSE:
        cdef int ret = tglutil.tglutil_set_console_size(col, row)
        if ret < 0:
            raise OSError(errno)


def set_window_title(bytes title not None) -> None:
    """
    Attempts to set window title

    :raises ImportError: On operating systems other than Linux or Windows
    """
    IF TERMGLUTIL == 0:
        raise ImportError("TermGLUtil is only available on Linux and Windows systems")
    ELSE:
        cdef int ret = tglutil.tglutil_set_window_title(title)
        if ret < 0:
            raise OSError(errno)


def set_echo_input(bint enabled) -> None:
    """Sets if stdin input is displayed / echoed.

    Set to `False` when using mouse tracking

    :raises ImportError: On operating systems other than Linux or Windows
    """
    IF TERMGLUTIL == 0:
        raise ImportError("TermGLUtil is only available on Linux and Windows systems")
    ELSE:
        cdef int ret = tglutil.tglutil_set_echo_input(enabled)
        if ret:
            raise OSError(errno)


def set_mouse_tracking_enabled(bint enabled) -> None:
    """
    Sets if mouse is tracked

    It is recommended to disable input echoing when using mouse tracking

    :raises ImportError: On operating systems other than Linux or Windows
    """
    IF TERMGLUTIL == 0:
        raise ImportError("TermGLUtil is only available on Linux and Windows systems")
    ELSE:
        cdef int ret = tglutil.tglutil_set_mouse_tracking_enabled(enabled)
        if ret:
            raise OSError(errno)


cdef class Gradient:
    """Gradient of characters from dark to bright."""
    cdef tgl.TGLGradient *_c_gradient
    cdef bint _ptr_owner
    _grad: bytes

    def __cinit__(self) -> None:
        self._ptr_owner = False

    def __dealloc__(self) -> None:
        if self._ptr_owner:
            PyMem_Free(self._c_gradient)

    def __init__(self, bytes grad not None) -> None:
        self._grad = grad
        self._ptr_owner = True
        self._c_gradient = <tgl.TGLGradient*>PyMem_Malloc(sizeof(tgl.TGLGradient))
        self._c_gradient.length = len(self._grad)
        self._c_gradient.grad = self._grad

    def char(self, uint8_t intensity) -> int:
        """Gets a gradient's character corresponding to an intensity (i.e. u or v value)."""
        return tgl.tgl_grad_char(self._c_gradient, intensity)

    @staticmethod
    cdef Gradient from_ptr(tgl.TGLGradient *gradient):
        cdef Gradient this = Gradient.__new__(Gradient)
        this._grad = bytes(gradient.grad)
        this._c_gradient = gradient
        return this

    @property
    def grad(self) -> bytes:
        return self._grad


gradient_full: Gradient = Gradient.from_ptr(&tgl.gradient_full)
gradient_min: Gradient = Gradient.from_ptr(&tgl.gradient_min)

cdef class PixelShader:
    """Pixel shader that is called for each pixel in draw functions."""
    cdef void *_c_data
    cdef tgl.TGLPixelShader *_c_pixel_shader

    def __cinit__(self) -> None:
        self._c_data = <void *>self
        self._c_pixel_shader = PixelShader._pixel_shader

    @staticmethod
    cdef void _pixel_shader(uint8_t u, uint8_t v, tgl.TGLPixFmt *color, char *c, const void *data) except *:
        cdef PixelShader self = <PixelShader>data
        (color_ret, c_ret) = self.pixel_shader(u, v)
        color[0] = (<PixFmt>color_ret)._c_pix_fmt
        c[0] = c_ret

    def pixel_shader(self, uint8_t u, uint8_t v) -> tuple[PixFmt, int]:
        raise NotImplementedError

cdef class VertexShader:
    """Vertex shader that should transform an input vertex into Clip Space."""
    cdef void *_c_data
    cdef tgl.TGLVertexShader *_c_vertex_shader

    def __cinit__(self) -> None:
        self._c_data = <void *>self
        self._c_vertex_shader = &VertexShader._vertex_shader

    @staticmethod
    cdef void _vertex_shader(const float *in_, tgl.TGLVec4 out, const void *data) except *:
        cdef VertexShader self = <VertexShader>data
        in_np = np.asarray(<tgl.TGLVec3>in_, dtype=np.float32)
        in_np.flags.writeable = False
        out_ret = self.vertex_shader(in_np)
        cdef float[::1] out_view = out_ret
        if out_view.shape[0] != 4:
            raise ValueError
        memcpy(out, &out_view[0], 4 * sizeof(float))

    def vertex_shader(self, float[:] in_) -> float[:]:
        raise NotImplementedError

cdef class VertexShaderSimple(VertexShader):
    """Vertex shader that outputs the input vertex multiplied by a matrix."""
    cdef tgl.TGLVertexShaderSimple _c_vertex_shader_simple

    def __cinit__(self) -> None:
        self._c_data = &self._c_vertex_shader_simple
        self._c_vertex_shader = tgl.tgl_vertex_shader_simple

    def __init__(self, float[:, ::1] mat not None) -> None:
        cdef float[:, ::1] mat_view = mat
        if mat_view.shape[0] != 4 or mat_view.shape[1] != 4:
            raise ValueError
        memcpy(&self._c_vertex_shader_simple.mat[0][0], &mat_view[0, 0], 4 * 4 * sizeof(float))

cdef class PixelShaderSimple(PixelShader):
    """Pixel shader that maps u+v onto a TGLGradient and has fixed color."""
    cdef tgl.TGLPixelShaderSimple _c_pixel_shader_simple
    _grad: Gradient

    def __cinit__(self, PixFmt color not None, Gradient grad not None) -> None:
        self._c_data = &self._c_pixel_shader_simple
        self._c_pixel_shader = tgl.tgl_pixel_shader_simple

        self._c_pixel_shader_simple.color = color._c_pix_fmt
        self._grad = grad
        self._c_pixel_shader_simple.grad = self._grad._c_gradient

    @property
    def grad(self) -> Gradient:
        return self._grad

    @grad.setter
    def grad(self, Gradient grad not None) -> None:
        self._grad = grad
        self._c_pixel_shader_simple.grad = self._grad._c_gradient

    @property
    def color(self) -> PixFmt:
        return PixFmt._from_c(self._c_pix_fmt)

    @color.setter
    def color(self, PixFmt color not None):
        self._c_pixel_shader_simple.color = color._c_pix_fmt

cdef class PixelShaderTexture(PixelShader):
    """Pixel shader that maps (u,v) onto a texture.

    :param pixels: 2D array with `dtype=TexPix`
    """
    cdef tgl.TGLPixelShaderTexture _c_pixel_shader_texture

    def __cinit__(self, pixels not None: TexPix[:, ::1]) -> None:
        self._c_data = &self._c_pixel_shader_texture
        self._c_pixel_shader = tgl.tgl_pixel_shader_texture

        height, width = pixels.shape
        cdef size_t nelem = height * width
        cdef char *chars = <char *>PyMem_Malloc(nelem)
        cdef tgl.TGLPixFmt *colors = <tgl.TGLPixFmt *>PyMem_Malloc(sizeof(tgl.TGLPixFmt) * nelem)

        self._c_pixel_shader_texture.width = width
        self._c_pixel_shader_texture.height = height
        self._c_pixel_shader_texture.chars = chars
        self._c_pixel_shader_texture.colors = colors

        cdef char[::1] chars_view = pixels["char"].ravel(order='C')
        memcpy(chars, &chars_view[0], nelem)

        for i, element in enumerate(pixels["pix_fmt"].flatten(order='C')):
            colors[i] = (<PixFmt>element)._c_pix_fmt

    def __dealloc__(self) -> None:
        PyMem_Free(self._c_pixel_shader_texture.chars)
        PyMem_Free(self._c_pixel_shader_texture.colors)


def camera(float[:, ::1] camera, int width, int height, float fov, float near_val, float far_val):
    """Sets `camera` to a camera matrix."""
    if camera.shape[0] != 4 or camera.shape[1] != 4:
        raise ValueError
    tgl.tgl_camera(<tgl.TGLVec4 *>&camera[0][0], width, height, fov, near_val, far_val)


def rotate(float[:, ::1] mat, float x, float y, float z):
    """Sets `mat` to a rotation matrix."""
    if mat.shape[0] != 4 or mat.shape[1] != 4:
        raise ValueError
    tgl.tgl_rotate(<tgl.TGLVec4 *>&mat[0][0], x, y, z)


def scale(float[:, ::1] mat, float x, float y, float z):
    """Sets `mat` to a scaling matrix."""
    if mat.shape[0] != 4 or mat.shape[1] != 4:
        raise ValueError
    tgl.tgl_scale(<tgl.TGLVec4 *>&mat[0][0], x, y, z)


def translate(float[:, ::1] mat, float x, float y, float z):
    """Sets `mat` to a translation matrix."""
    if mat.shape[0] != 4 or mat.shape[1] != 4:
        raise ValueError
    tgl.tgl_translate(<tgl.TGLVec4 *>&mat[0][0], x, y, z)


cdef bint _booted = False

cdef class TGL:
    """Rendering context that is passed to most functions."""
    cdef tgl.TGL *_c_tgl

    def __cinit__(self, unsigned width, unsigned height) -> None:
        cdef int ret
        global _booted
        if not _booted:
            ret = tgl.tgl_boot()
            if ret:
                raise OSError(errno)
            _booted = True

        self._c_tgl = tgl.tgl_init(width, height)
        if self._c_tgl is NULL:
            raise MemoryError(errno)

    def __dealloc__(self) -> None:
        if self._c_tgl is not NULL:
            tgl.tgl_delete(self._c_tgl)

    def flush(self) -> None:
        """Prints frame buffer to terminal."""
        cdef int ret = tgl.tgl_flush(self._c_tgl)
        if ret < 0:
            raise OSError(errno)

    def clear(self, buffers not None: Buffer) -> None:
        """Clears buffers."""
        tgl.tgl_clear(self._c_tgl, buffers)

    def enable(self, settings not None: Setting) -> None:
        """Enables certain settings."""
        cdef int ret = tgl.tgl_enable(self._c_tgl, settings)
        if ret < 0:
            raise MemoryError(errno)

    def disable(self, settings not None: Setting) -> None:
        """Disables certain settings."""
        tgl.tgl_disable(self._c_tgl, settings)

    def putchar(self, c not None: Char | Char[:], PixFmt color not None) -> None:
        """Prints a single character or array of characters.

        :param c: 0D or 1D array with `dtype=Char`
        """
        if c.dtype != Char:
            raise ValueError
        for char_ in np.atleast_1d(c):
            tgl.tgl_putchar(self._c_tgl, char_['x'], char_['y'], char_["char"], color._c_pix_fmt)

    def puts(self, int x, int y, char *c, PixFmt color not None) -> None:
        """Prints a string."""
        tgl.tgl_puts(self._c_tgl, x, y, c, color._c_pix_fmt)

    def point(self, v not None: Vert | Vert[:], PixelShader pixel_shader not None) -> None:
        """Draws a single point or array of points.

        :param v: 0D or 1D array with `dtype=Vert`
        """
        if v.dtype != Vert:
            raise ValueError
        for vert in np.atleast_1d(v):
            tgl.tgl_point(self._c_tgl, vert, pixel_shader._c_pixel_shader, pixel_shader._c_data)

    def line(self, v not None: Vert[:] | Vert[:, :], PixelShader pixel_shader not None) -> None:
        """Draws a single line or array of lines.

        :param v: 1D or 2D array with `dtype=Vert`
        """
        if v.dtype != Vert:
            raise ValueError
        for verts in np.atleast_2d(v):
            tgl.tgl_line(self._c_tgl, verts[0], verts[1], pixel_shader._c_pixel_shader, pixel_shader._c_data)

    def triangle(self, v not None: Vert[:] | Vert[:, :], PixelShader pixel_shader not None, bint fill = False) -> None:
        """Draws a single triangle or array of triangles.

        :param v: 1D or 2D array with `dtype=Vert`
        """
        if v.dtype != Vert:
            raise ValueError
        cdef void (*f)(tgl.TGL *, tgl.TGLVert, tgl.TGLVert, tgl.TGLVert, tgl.TGLPixelShader *, const void *)
        f = tgl.tgl_triangle_fill if fill else tgl.tgl_triangle
        for verts in np.atleast_2d(v):
            f(self._c_tgl, verts[0], verts[1], verts[2], pixel_shader._c_pixel_shader, pixel_shader._c_data)

    def cull_face(self, face not None: Face, winding not None: Winding) -> None:
        """Sets which face should be culled.

        Requires `Setting.CULL_FACE` to be enabled for faces to be culled.
        """
        tgl.tgl_cull_face(self._c_tgl, face | winding)

    def triangle_3d(self, trigs not None: Trig3D | Trig3D[:], VertexShader vertex_shader not None, PixelShader pixel_shader not None) -> None:
        """Draws a single triangle or array of triangles.

        :param trigs: 0D or 1D array with `dtype=Trig3D`
        """
        if trigs.dtype != Trig3D:
            raise ValueError
        cdef float[:, ::1] in_
        cdef uint8_t[:, ::1] uv
        cdef bint fill

        for vert in np.atleast_1d(trigs):
            in_ = vert["verts"]
            uv = vert["uv"]
            fill = vert["fill"]

            tgl.tgl_triangle_3d(self._c_tgl, <tgl.TGLVec3 *>&in_[0][0], <uint8_t (*)[2]>&uv[0][0], fill, vertex_shader._c_vertex_shader, vertex_shader._c_data, pixel_shader._c_pixel_shader, pixel_shader._c_data)
