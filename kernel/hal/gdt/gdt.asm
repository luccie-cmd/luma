global halInitGDT
extern dbgPuts
section .text
halInitGDT:
    push rax
    push rdi
    lea rax, [GDTR]
    lgdt [rax]
    push 0x08
    lea rax, [.reload_CS]
    push rax
    retfq
.reload_CS:
    mov rax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    pop rdi
    pop rax
    ret

section .data
global GDT
GDT:
    dq 0
    dq 0x00AF9A000000FFFF
    dq 0x00AF92000000FFFF
    dq 0x00AFFA000000FFFF
    dq 0x00AFF2000000FFFF
    dq 0x0000000000000000
    dq 0x0000000000000000
GDTR:
    dw GDT_end - GDT - 1
    dq GDT
GDT_end: