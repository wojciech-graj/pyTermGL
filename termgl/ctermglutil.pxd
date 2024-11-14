from libc.stdint cimport uint8_t


cdef extern from "termgl.h":
    cdef uint8_t TGL_MOUSE_UNKNOWN
    cdef uint8_t TGL_MOUSE_RELEASE
    cdef uint8_t TGL_MOUSE_1
    cdef uint8_t TGL_MOUSE_2
    cdef uint8_t TGL_MOUSE_3
    cdef uint8_t TGL_MOUSE_WHEEL_OR_MOVEMENT

    ctypedef struct TGLMouseEvent:
        uint8_t button
        uint8_t x
        uint8_t y

    ssize_t tglutil_read(char *buf, size_t count, TGLMouseEvent *event_buf, size_t count_events, size_t *count_read_events)
    int tglutil_get_console_size(unsigned *col, unsigned *row, bint screen_buffer)
    int tglutil_set_console_size(unsigned col, unsigned row)
    int tglutil_set_window_title(const char *title)
    int tglutil_set_echo_input(bint enabled)
    int tglutil_set_mouse_tracking_enabled(bint enabled)
