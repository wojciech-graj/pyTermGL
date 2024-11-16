from dataclasses import dataclass
from enum import IntFlag, IntEnum
from typing import Any, Optional, Literal

import numpy as np

TERMGL_VERSION: tuple[int, int]
Vert: np.dtype
Trig3D: np.dtype
TexPix: np.dtype
Char: np.dtype


class Setting(IntFlag):
    OUTPUT_BUFFER: int
    Z_BUFFER: int
    DOUBLE_WIDTH: int
    DOUBLE_CHARS: int
    PROGRESSIVE: int
    CULL_FACE: int


class Buffer(IntFlag):
    FRAME: int
    Z: int
    OUTPUT: int


class Color(IntEnum):
    BLACK: int
    RED: int
    GREEN: int
    YELLOW: int
    BLUE: int
    PURPLE: int
    CYAN: int
    WHITE: int


class FmtFlag(IntFlag):
    BOLD: int
    UNDERLINE: int


class Face(IntEnum):
    BACK: int
    FRONT: int


class Winding(IntEnum):
    CW: int
    CCW: int


class MouseButton(IntEnum):
    ...


class Fmt:

    @property
    def flags(self) -> FmtFlag:
        ...

    @flags.setter
    def flags(self, flags: FmtFlag) -> None:
        ...


class RGB(Fmt):

    def __init__(self,
                 r: int,
                 g: int,
                 b: int,
                 flags: Optional[FmtFlag] = None) -> None:
        ...

    @property
    def r(self) -> int:
        ...

    @r.setter
    def r(self, r: int) -> None:
        ...

    @property
    def g(self) -> int:
        ...

    @g.setter
    def g(self, g: int) -> None:
        ...

    @property
    def b(self) -> int:
        ...

    @b.setter
    def b(self, b: int) -> None:
        ...


class Idx(Fmt):

    def __init__(self,
                 color: Color,
                 high_intensity: bool = False,
                 flags: Optional[FmtFlag] = None) -> None:
        ...

    @property
    def color(self) -> Color:
        ...

    @color.setter
    def color(self, color: Color) -> None:
        ...

    @property
    def high_intensity(self) -> bool:
        ...

    @high_intensity.setter
    def high_intensity(self, high_intensity: bool) -> None:
        ...


class PixFmt:

    def __init__(self,
                 fg: Optional[Fmt] = None,
                 bkg: Optional[Fmt] = None) -> None:
        ...

    @property
    def fg(self) -> Fmt:
        ...

    @fg.setter
    def fg(self, fg: Fmt) -> None:
        ...

    @property
    def bkg(self) -> Fmt:
        ...

    @bkg.setter
    def bkg(self, bkg: Fmt) -> None:
        ...


@dataclass
class MouseEvent:
    button: MouseButton
    mouse_wheel_or_movement: bool
    x: int
    y: int


BLACK: PixFmt
RED: PixFmt
GREEN: PixFmt
YELLOW: PixFmt
BLUE: PixFmt
PURPLE: PixFmt
CYAN: PixFmt
WHITE: PixFmt


def clear_screen() -> None:
    ...


def flush() -> None:
    ...


def read(count: int,
         count_events: int = 0) -> tuple[bytes, Optional[list[MouseEvent]]]:
    ...


def get_console_size(screen_buffer: int = True) -> tuple[int, int]:
    ...


def set_console_size(col: int, row: int) -> None:
    ...


def set_window_title(title: bytes) -> None:
    ...


def set_echo_input(enabled: bool) -> None:
    ...


def set_mouse_tracking_enabled(enabled: bool) -> None:
    ...


class Gradient:

    def __init__(self, grad: bytes) -> None:
        ...

    @property
    def grad(self) -> bytes:
        ...

    def char(self, intensity: int) -> int:
        ...


gradient_full: Gradient
gradient_min: Gradient


class PixelShader:

    def pixel_shader(self, u: int, v: int) -> tuple[PixFmt, int]:
        ...


class VertexShader:

    def vertex_shader(
        self, in_: np.ndarray[tuple[Literal[3]], np.dtype[np.float32]]
    ) -> np.ndarray[tuple[Literal[4]], np.dtype[np.float32]]:
        ...


class VertexShaderSimple(VertexShader):

    def __init__(
        self, mat: np.ndarray[tuple[Literal[4], Literal[4]],
                              np.dtype[np.float32]]
    ) -> None:
        ...


class PixelShaderSimple(PixelShader):

    def __init__(self, color: PixFmt, grad: Gradient) -> None:
        ...

    @property
    def grad(self) -> Gradient:
        ...

    @grad.setter
    def grad(self, grad: Gradient) -> None:
        ...

    @property
    def color(self) -> PixFmt:
        ...

    @color.setter
    def color(self, color: PixFmt):
        ...


class PixelShaderTexture(PixelShader):

    def __init__(self, pixels: np.ndarray[tuple[Any, Any],
                                          np.dtype[Any]]) -> None:
        ...


def camera(camera: np.ndarray[tuple[Literal[4], Literal[4]],
                              np.dtype[np.float32]], width: int, height: int,
           fov: float, near_val: float, far_val: float):
    ...


def rotate(mat: np.ndarray[tuple[Literal[4], Literal[4]],
                           np.dtype[np.float32]], x: float, y: float,
           z: float):
    ...


def scale(mat: np.ndarray[tuple[Literal[4], Literal[4]], np.dtype[np.float32]],
          x: float, y: float, z: float):
    ...


def translate(mat: np.ndarray[tuple[Literal[4], Literal[4]],
                              np.dtype[np.float32]], x: float, y: float,
              z: float):
    ...


class TGL:

    def __init__(self, width: int, height: int) -> None:
        ...

    def flush(self) -> None:
        ...

    def clear(self, buffers: Buffer) -> None:
        ...

    def enable(self, settings: Setting) -> None:
        ...

    def disable(self, settings: Setting) -> None:
        ...

    def putchar(self, c: np.ndarray[tuple[()] | tuple[Any], np.dtype[Any]],
                color: PixFmt) -> None:
        ...

    def puts(self, x: int, y: int, c: bytes, color: PixFmt) -> None:
        ...

    def point(self, v: np.ndarray[tuple[()] | tuple[Any], np.dtype[Any]],
              pixel_shader: PixelShader) -> None:
        ...

    def line(self, v: np.ndarray[tuple[Literal[2]] | tuple[Any, Literal[2]],
                                 np.dtype[Any]],
             pixel_shader: PixelShader) -> None:
        ...

    def triangle(self,
                 v: np.ndarray[tuple[Literal[3]] | tuple[Any, Literal[3]],
                               np.dtype[Any]],
                 pixel_shader: PixelShader,
                 fill: bool = False) -> None:
        ...

    def cull_face(self, face: Face, winding: Winding) -> None:
        ...

    def triangle_3d(self, trigs: np.ndarray[tuple[()] | tuple[Any],
                                            np.dtype[Any]],
                    vertex_shader: VertexShader,
                    pixel_shader: PixelShader) -> None:
        ...
