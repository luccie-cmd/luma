global vmmMakeVirtual
global vmmInit
extern dbgPuts
extern abort
section .text
vmmInit:
    push rdi
    mov rdi, str0
    call dbgPuts
    mov rdi, [hhdm_request.response]
    cmp rdi, 0
    je .failHHDM
    mov rdi, [rdi+8]
    mov QWORD [hhdm_offset], rdi
    mov [initialized], BYTE 1
    mov rdi, str2
    call dbgPuts
    pop rdi
    ret
.failHHDM:
    mov rdi, str1
    call dbgPuts
    call abort

vmmMakeVirtual:
    movzx rax, BYTE [initialized]
    cmp rax, 1
    je .afterCheck
    call vmmInit
.afterCheck:
    mov rax, rdi
    add rax, [hhdm_offset]
    ret

section .rodata
str0: db "Initializing virtual memory", 0x0a, 0
str1: db "Failed to get HHDM", 0x0a, 0
str2: db "Initialized virtual memory", 0x0a, 0

section .bss
hhdm_offset: resq 1
initialized: resb 1

section .limine_requests
align 16
%define LIMINE_COMMON_MAGIC 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b
%define LIMINE_HHDM_REQUEST LIMINE_COMMON_MAGIC, 0x48dcf1cb8ad2b852, 0x63984e959a98244b
global hhdm_request
hhdm_request:
    .id:       dq LIMINE_HHDM_REQUEST
    .revision: dq 0
    .response: dq 0