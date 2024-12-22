global vsnprintf
extern stbsp_vsnprintf
section .text
vsnprintf:
    jmp stbsp_vsnprintf