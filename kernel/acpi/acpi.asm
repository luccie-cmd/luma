global acpiInit
extern abort
extern dbgPuts
extern vmmMakeVirtual
section .text
acpiInit:
    push rdi
    mov rdi, str0
    call dbgPuts
    mov rdi, [rsdp_request.response]
    cmp rdi, 0
    je .failRSDP
    mov rdi, QWORD [rdi+8]
    call vmmMakeVirtual
    mov [XSDT], rax
    ; call initFADT
    mov rdi, str2
    call dbgPuts
    pop rdi
    ret
.failRSDP:
    mov rdi, str1
    call dbgPuts
    call abort

section .rodata
str0: db "Initializing ACPI subsystem", 0x0a, 0
str1: db "Failed to get RSDP", 0x0a, 0
str2: db "Initialized ACPI subsystem", 0x0a, 0

section .bss
XSDT: resq 1

section .limine_requests
align 16
%define LIMINE_COMMON_MAGIC 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b
%define LIMINE_RSDP_REQUEST LIMINE_COMMON_MAGIC, 0xc5e77b6b397e7b43, 0x27637845accdcf3c
global rsdp_request
rsdp_request:
    .id:       dq LIMINE_RSDP_REQUEST
    .revision: dq 0
    .response: dq 0