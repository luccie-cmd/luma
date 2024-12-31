global initLAPIC
global LAPICread
global LAPICwrite
extern dbgPrintf
extern vmmMakeVirtual
section .text
initLAPIC:
    push rcx
    push rdx
    push rdi
    push rsi
    mov rcx, 0x1b
    rdmsr
    shl rdx, 32
    or rax, rdx
    mov rdx, 0xfffff000
    and rax, rdx
    mov [mmio_base], rax
    mov rdi, 0xf0
    call LAPICread
    mov rsi, 0x100
    or rax, rsi
    mov rsi, rax
    call LAPICwrite
    inc BYTE [lapic_count]
    mov rsi, [lapic_count]
    mov rdi, str0
    call dbgPrintf
    pop rsi
    pop rdi
    pop rdx
    pop rcx 
    ret

LAPICread:
    push rdx
    push rdi
    mov rdx, rdi
    mov rdi, [mmio_base]
    call vmmMakeVirtual
    add rax, rdx
    mov eax, DWORD [rax]
    pop rdi
    pop rdx
    ret

LAPICwrite:
    push rdx
    push rdi
    mov rdx, rdi
    mov rdi, [mmio_base]
    call vmmMakeVirtual
    add rax, rdx
    mov [rax], esi
    pop rdi
    pop rdx
    ret

section .bss
mmio_base: resq 1
lapic_count: resb 1

section .limine_requests
align 16
%define LIMINE_COMMON_MAGIC 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b
%define LIMINE_SMP_REQUEST LIMINE_COMMON_MAGIC, 0x95a67b819a1b857e, 0xa0b61b723b6a73e0
global smp_request
smp_request:
    .id:       dq LIMINE_SMP_REQUEST
    .revision: dq 0
    .response: dq 0

section .rodata
str0: db "Initialized LAPIC #%d", 0x0a, 0