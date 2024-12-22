global dbgPuts
global dbgPrintf
extern vsnprintf
section .text
dbgPuts:
    jmp .condition
.loop:
    out 0xE9, al
    inc rdi
.condition:
    movzx rax, BYTE [rdi]
    cmp rax, 0
    jne .loop
    ret

dbgPrintf:
    push rax
    push rsi
    push rdx
    push rdi
    push rcx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    sub rsp, 136
    lea rax, [rsp+96]
    mov QWORD [rsp+40], rsi
    mov rsi, 8192
    mov QWORD [rsp+48], rdx
    mov rdx, rdi
    mov rdi, buffer
    mov QWORD [rsp+56], rcx
    lea rcx, [rsp+8]
    mov QWORD [rsp+16], rax
    lea rax, [rsp+32]
    mov QWORD [rsp+64], r8
    mov QWORD [rsp+72], r9
    mov QWORD [rsp+80], r10
    mov QWORD [rsp+88], r11
    mov QWORD [rsp+96], r12
    mov QWORD [rsp+104], r13
    mov QWORD [rsp+112], r14
    mov QWORD [rsp+120], r15
    mov QWORD [rsp+24], rax
    mov DWORD [rsp+8], 8
    call vsnprintf
    call dbgPuts
    add rsp, 136
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdi
    pop rdx
    pop rsi
    pop rax
    ret

section .bss
buffer:
    resb 8192