from libc.stdint cimport uint8_t, uint16_t


cdef extern from "termgl.h":
    cdef uint8_t TGL_VERSION_MAJOR
    cdef uint8_t TGL_VERSION_MINOR

    ctypedef struct TGLGradient:
        unsigned length
        char *grad

    cdef TGLGradient gradient_full
    cdef TGLGradient gradient_min

    ctypedef struct TGL:
        pass

    cdef uint8_t TGL_FRAME_BUFFER
    cdef uint8_t TGL_OUTPUT_BUFFER
    cdef uint8_t TGL_Z_BUFFER
    cdef uint8_t TGL_DOUBLE_CHARS
    cdef uint8_t TGL_PROGRESSIVE
    cdef uint8_t TGL_CULL_FACE

    cdef uint16_t TGL_BLACK
    cdef uint16_t TGL_RED
    cdef uint16_t TGL_GREEN
    cdef uint16_t TGL_YELLOW
    cdef uint16_t TGL_BLUE
    cdef uint16_t TGL_PURPLE
    cdef uint16_t TGL_CYAN
    cdef uint16_t TGL_WHITE

    cdef uint16_t TGL_BLACK_BKG
    cdef uint16_t TGL_RED_BKG
    cdef uint16_t TGL_GREEN_BKG
    cdef uint16_t TGL_YELLOW_BKG
    cdef uint16_t TGL_BLUE_BKG
    cdef uint16_t TGL_PURPLE_BKG
    cdef uint16_t TGL_CYAN_BKG
    cdef uint16_t TGL_WHITE_BKG

    cdef uint16_t TGL_HIGH_INTENSITY
    cdef uint16_t TGL_HIGH_INTENSITY_BKG
    cdef uint16_t TGL_BOLD
    cdef uint16_t TGL_UNDERLINE

    TGL *tgl_init(unsigned width, unsigned height, const TGLGradient *gradient)
    void tgl_delete(TGL *tgl)
    int tgl_flush(TGL *tgl)
    void tgl_clear(TGL *tgl, uint8_t buffers)
    void tgl_clear_screen()
    int tgl_enable(TGL *tgl, uint8_t settings)
    void tgl_disable(TGL *tgl, uint8_t settings)
    void tgl_putchar(TGL *tgl, int x, int y, char c, uint16_t color)
    void tgl_puts(TGL *tgl, int x, int y, char *str, uint16_t color)
    void tgl_point(TGL *tgl, int x, int y, float z, uint8_t i, uint16_t color)
    void tgl_line(TGL *tgl, int x0, int y0, float z0, uint8_t i0,
                  int x1, int y1, float z1, uint8_t i1, uint16_t color)
    void tgl_triangle(TGL *tgl, int x0, int y0, float z0, uint8_t i0,
                      int x1, int y1, float z1, uint8_t i1,
                      int x2, int y2, float z2, int i2, uint16_t color)
    void tgl_triangle_fill(TGL *tgl, int x0, int y0, float z0, uint8_t i0,
                           int x1, int y1, float z1, uint8_t i1,
                           int x2, int y2, float z2, int i2, uint16_t color)

    cdef uint8_t TGL_BACK
    cdef uint8_t TGL_FRONT
    cdef uint8_t TGL_CW
    cdef uint8_t TGL_CCW

    ctypedef float TGLMat[4][4]
    ctypedef float TGLVec3[3]

    ctypedef struct TGLTransform:
        TGLMat rotate
        TGLMat scale
        TGLMat translate
        TGLMat result

    ctypedef struct TGLTriangle:
        TGLVec3 vertices[3]
        uint8_t intensity[3]

    int tgl3d_init(TGL *tgl)
    void tgl3d_camera(TGL *tgl, float fov, float near_val, float far_val)
    TGLTransform *tgl3d_get_transform(const TGL *tgl)
    void tgl3d_cull_face(TGL *tgl, uint8_t settings)
    void tgl3d_shader(TGL *tgl, const TGLTriangle *input, uint16_t color,
                      bint fill, void *data,
                      void (*intermediate_shader)(TGLTriangle*, void*))
    void tgl3d_transform_rotate(TGLTransform *transform, float x, float y, float z)
    void tgl3d_transform_scale(TGLTransform *transform, float x, float y, float z)
    void tgl3d_transform_translate(TGLTransform *transform, float x, float y, float z)
    void tgl3d_transform_update(TGLTransform *transform)
    void tgl3d_transform_apply(TGLTransform *transform, float *inp, float *outp)

    ssize_t tglutil_read(char *buf, size_t count)
    int tglutil_get_console_size(unsigned *col, unsigned *row,
                                 bint screen_buffer)
    int tglutil_set_console_size(unsigned col, unsigned row)
