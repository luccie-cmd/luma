global halInitIDT
global registerHandler
global enableGate
extern HalInitISRGates
extern dbgPrintf
extern dbgPuts
extern abort
section .text
halInitIDT:
    push rdi
    push rsi
    mov rdi, str0
    call dbgPuts
    mov rdi, IDT
    lidt [rdi]
    call HalInitISRGates
    xor rdi, rdi
    mov rsi, 255
.loop:
    call enableGate
    inc rdi
.condition:
    cmp rdi, rsi
    jle .loop
    pop rsi
    pop rdi
    ret

%define IDT_OFFSET0_MASK      0xFFFF
%define IDT_SEGMENT_SEL_MASK  0xFFFF
%define IDT_IST_MASK          0b00000111
%define IDT_RESERVED0_MASK    0b11111000
%define IDT_GATE_TYPE_MASK    0b00001111
%define IDT_ZERO_MASK         0b00010000
%define IDT_DPL_MASK          0b01100000
%define IDT_PRESENT_MASK      0b10000000
%define IDT_OFFSET1_MASK      0xFFFF
%define IDT_OFFSET2_MASK      0xFFFFFFFF
%define IDT_RESERVED1_MASK    0xFFFFFFFF

%define IDT_IST_SHIFT         0
%define IDT_RESERVED0_SHIFT   3
%define IDT_GATE_TYPE_SHIFT   0
%define IDT_ZERO_SHIFT        4
%define IDT_DPL_SHIFT         5
%define IDT_PRESENT_SHIFT     7

registerHandler:
    push rdi
    push rsi
    push r8
    push rdx
    lea r8, entries
    sal rdi, 4
    add r8, rdi
    mov WORD [r8], si
    mov WORD [r8+2], 0x8
    mov BYTE [r8+4], 0
    movzx rdi, BYTE [r8+5]
    shl rdx, IDT_GATE_TYPE_SHIFT
    or rdi, rdx
    mov BYTE [r8+5], dil
    push rsi
    shr rsi, 16
    mov WORD [r8+6], si
    pop rsi
    shr rsi, 32
    mov DWORD [r8+8], esi
    pop rdx
    pop r8
    pop rsi
    pop rdi
    ret

enableGate:
    push rsi
    push rdi
    lea rsi, entries
    sal rdi, 4
    add rsi, rdi
    movzx rdi, BYTE [rsi+5]
    or rdi, IDT_PRESENT_MASK
    mov BYTE [rsi+5], dil
    pop rdi
    pop rsi
    ret

section .bss
entries: resb 4096

section .rodata
str0: db "Setting IDT", 0x0a, 0
IDT:
    .limit: dw 4095
    .base:  dq entries