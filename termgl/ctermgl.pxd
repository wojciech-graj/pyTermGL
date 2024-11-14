from libc.stdint cimport uint8_t


cdef extern from "termgl.h":
    cdef uint8_t TGL_VERSION_MAJOR
    cdef uint8_t TGL_VERSION_MINOR

    cdef uint8_t TGL_BLACK
    cdef uint8_t TGL_RED
    cdef uint8_t TGL_GREEN
    cdef uint8_t TGL_YELLOW
    cdef uint8_t TGL_BLUE
    cdef uint8_t TGL_PURPLE
    cdef uint8_t TGL_CYAN
    cdef uint8_t TGL_WHITE
    cdef uint8_t TGL_HIGH_INTENSITY

    cdef uint8_t TGL_NONE
    cdef uint8_t TGL_RGB24
    cdef uint8_t TGL_BOLD
    cdef uint8_t TGL_UNDERLINE

    cdef uint8_t TGL_FRAME_BUFFER
    cdef uint8_t TGL_OUTPUT_BUFFER
    cdef uint8_t TGL_Z_BUFFER
    cdef uint8_t TGL_DOUBLE_WIDTH
    cdef uint8_t TGL_DOUBLE_CHARS
    cdef uint8_t TGL_PROGRESSIVE
    cdef uint8_t TGL_CULL_FACE

    ctypedef struct TGL:
        pass

    ctypedef struct TGLVert:
        int x
        int y
        float z
        uint8_t u
        uint8_t v

    ctypedef struct TGLRGB:
        uint8_t r
        uint8_t g
        uint8_t b

    cdef union TGLFmtColor:
        TGLRGB rgb
        uint8_t indexed

    ctypedef struct TGLFmt:
        uint8_t flags
        TGLFmtColor color

    ctypedef struct TGLPixFmt:
        TGLFmt fg
        TGLFmt bkg

    ctypedef void TGLPixelShader(uint8_t u, uint8_t v, TGLPixFmt *color, char *c, const void *data) except *

    ctypedef struct TGLGradient:
        unsigned length
        char *grad

    ctypedef struct TGLPixelShaderSimple:
        TGLPixFmt color
        const TGLGradient *grad

    ctypedef struct TGLPixelShaderTexture:
        uint8_t width
        uint8_t height
        const char *chars
        const TGLPixFmt *colors

    cdef TGLGradient gradient_full
    cdef TGLGradient gradient_min

    void tgl_pixel_shader_simple(uint8_t u, uint8_t v, TGLPixFmt *color, char *c, const void *data)
    void tgl_pixel_shader_texture(uint8_t u, uint8_t v, TGLPixFmt *color, char *c, const void *data)
    char tgl_grad_char(const TGLGradient *grad, uint8_t intensity)

    int tgl_boot()
    TGL *tgl_init(unsigned width, unsigned height)
    void tgl_delete(TGL *tgl)
    int tgl_flush(TGL *tgl)
    void tgl_clear(TGL *tgl, uint8_t buffers)
    void tgl_clear_screen()
    int tgl_enable(TGL *tgl, uint8_t settings)
    void tgl_disable(TGL *tgl, uint8_t settings)
    void tgl_putchar(TGL *tgl, int x, int y, char c, TGLPixFmt color)
    void tgl_puts(TGL *tgl, int x, int y, char *str, TGLPixFmt color)
    void tgl_point(TGL *tgl, TGLVert v0, TGLPixelShader *t, const void *data) except *
    void tgl_line(TGL *tgl, TGLVert v0, TGLVert v1, TGLPixelShader *t, const void *data) except *
    void tgl_triangle(TGL *tgl, TGLVert v0, TGLVert v1, TGLVert v2, TGLPixelShader *t, const void *data) except *
    void tgl_triangle_fill(TGL *tgl, TGLVert v0, TGLVert v1, TGLVert v2, TGLPixelShader *t, const void *data) except *

    cdef uint8_t TGL_BACK
    cdef uint8_t TGL_FRONT
    cdef uint8_t TGL_CW
    cdef uint8_t TGL_CCW

    ctypedef float TGLMat[4][4]
    ctypedef float TGLVec3[3]
    ctypedef float TGLVec4[4]
    ctypedef TGLVec3 TGLTriangle[3]

    ctypedef void TGLVertexShader(const TGLVec3 in_, TGLVec4 out, const void *data) except *

    ctypedef struct TGLVertexShaderSimple:
        TGLMat mat

    void tgl_vertex_shader_simple(const TGLVec3 vert, TGLVec4 out, const void *data) except *

    void tgl_camera(TGLMat camera, int width, int height, float fov, float near_val, float far_val)
    void tgl_rotate(TGLMat rotate, float x, float y, float z)
    void tgl_scale(TGLMat scale, float x, float y, float z)
    void tgl_translate(TGLMat translate, float x, float y, float z)

    void tgl_cull_face(TGL *tgl, uint8_t settings)

    void tgl_triangle_3d(TGL *tgl, const TGLTriangle in_, const uint8_t (*uv)[2], bint fill, TGLVertexShader *vert_shader, const void *vert_data, TGLPixelShader *frag_shader, const void *frag_data) except *
