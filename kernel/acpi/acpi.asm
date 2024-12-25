global acpiInit
global acpiGetTableBySignature
extern abort
extern dbgPrintf
extern dbgPuts
extern vmmMakeVirtual
extern memcmp
section .text
acpiInit:
    push rdi
    push rsi
    mov rdi, str0
    call dbgPuts
    mov rdi, [rsdp_request.response]
    cmp rdi, 0
    je .failRSDP
    mov rdi, QWORD [rdi+8]
    mov [XSDP], rdi
    mov rdi, [rdi+24]
    call vmmMakeVirtual
    mov QWORD [XSDT], rax
    call getEntries
    call initFADT
    mov BYTE [initialized], 1
    mov rsi, [numberOfTables]
    mov rdi, str2
    call dbgPuts
    pop rsi
    pop rdi
    ret
.failRSDP:
    mov rdi, str1
    call dbgPuts
    call abort

getEntries:
    mov rax, [XSDT]
    mov eax, DWORD [rax+4]
    sub rax, 36
    shr rax, 3
    mov [numberOfTables], rax
    ret

acpiGetTableBySignature:
    cmp BYTE [initialized], 1
    je .afterInitCheck
    call getEntries
.afterInitCheck:
    push rdi
    push rsi
    push rdx
    push rcx
    mov rcx, [XSDT]
    lea rcx, [rcx+36]
    mov rdx, rdi
    mov rsi, [numberOfTables]
    xor rdi, rdi
    jmp .condition
.loop:
    push rdi
    push rsi
    push rdx
    mov rdi, [rcx+(rdi*8)]
    mov rsi, rdx
    mov rdx, 4
    call memcmp
    pop rdx
    pop rsi
    cmp rax, 0
    mov rax, rdi
    pop rdi
    jne .loopAfterMemcmp
    mov rsi, rdx
    mov rdx, rax
    mov rdi, str7
    call dbgPrintf
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    ret
.loopAfterMemcmp:
    inc rdi
.condition:
    cmp rdi, rsi
    jl .loop
.notFound:
    mov rsi, rdx
    mov rdi, str6
    call dbgPrintf
    call abort

initFADT:
    push rdi
    mov rdi, str3
    call dbgPuts
    mov rdi, str5
    call acpiGetTableBySignature
    call abort
    mov rdi, str4
    call dbgPuts
    pop rdi
    ret

section .rodata
str0: db "Initializing ACPI subsystem", 0x0a, 0
str1: db "Failed to get RSDP", 0x0a, 0
str2: db "Initialized ACPI subsystem", 0x0a, 0x09, "0x%ld entries present", 0x0a, 0
str3: db "Loading FADT", 0x0a, 0
str4: db "Loaded FADT", 0x0a, 0
str5: db "FACP"
str6: db "Not able to find table `%.4s`", 0x0a, 0
str7: db "Loaded %.4s at 0x%lx", 0x0a, 0

section .bss
XSDP: resq 1
XSDT: resq 1
FADT: resq 1
numberOfTables: resq 1
initialized: resb 1

section .limine_requests
align 16
%define LIMINE_COMMON_MAGIC 0xc7b1dd30df4c8b88, 0x0a82e883a194f07b
%define LIMINE_RSDP_REQUEST LIMINE_COMMON_MAGIC, 0xc5e77b6b397e7b43, 0x27637845accdcf3c
global rsdp_request
rsdp_request:
    .id:       dq LIMINE_RSDP_REQUEST
    .revision: dq 0
    .response: dq 0