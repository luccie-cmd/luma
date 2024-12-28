global acpiInit
global acpiGetTableBySignature
global acpiPrintTableSignatures
extern abort
extern dbgPrintf
extern dbgPuts
extern vmmMakeVirtual
extern strncmp
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
    call dbgPrintf
    pop rsi
    pop rdi
    ret
.failRSDP:
    mov rdi, str1
    call dbgPuts
    call abort

getEntries:
    cmp QWORD [numberOfTables], 0
    jne .end
    mov rax, [XSDT]
    mov eax, DWORD [rax+4]
    sub rax, 36
    shr rax, 3
    mov [numberOfTables], rax
    push rdi
    push rsi
    mov rsi, [XSDT]
    lea rsi, [rsi+36]
    xor rdi, rdi
    lea rdx, tables
    jmp .condition
.loop:
    push rsi
    mov rsi, [rsi+(rdi*8)]
    shl rdi, 3
    add rdx, rdi
    mov [rdx], rsi
    sub rdx, rdi
    shr rdi, 3
    pop rsi
    inc rdi
.condition:
    cmp rdi, rax
    jl .loop
    pop rsi
    pop rdi
.end:
    ret

acpiGetTableBySignature:
    cmp BYTE [initialized], 1
    je .afterInitCheck
    call getEntries
.afterInitCheck:
    push rdi
    push rsi
    push rdx
    push r15
    mov r15, rdi
    lea rdi, tables
    xor rsi, rsi
    mov rdx, [numberOfTables]
.loop:
    push rdi
    push rsi
    push rdx
    push r14
    shl rsi, 3
    add rdi, rsi
    mov r14, [rdi]
    mov rdi, [r14]
    mov rsi, [r15]
    cmp edi, esi
    jne .continue
    mov rax, r14
    pop r14
    pop rdx
    pop rsi
    pop rdi
    pop r15
    pop rdx
    pop rsi
    pop rdi
    ret
.continue:
    pop r14
    pop rdx
    pop rsi
    pop rdi
    inc rsi
.condition:
    cmp rsi, rdx
    jl .loop
    mov rdi, str6
    mov rsi, r15
    call dbgPrintf
    call abort

acpiPrintTableSignatures:
    push rdi
    push rsi
    push rcx
    mov rdi, [numberOfTables]
    mov rsi, [XSDT]
    lea rsi, [rsi+36]
    xor rcx, rcx
    jmp .condition
.loop:
    push rdi
    push rsi
    mov rsi, [rsi+(rcx*8)]
    mov rdi, str11
    call dbgPrintf
    pop rsi
    pop rdi
    inc rcx
.condition:
    cmp rcx, rdi
    jl .loop
    pop rcx
    pop rsi
    pop rdi
    ret

initFADT:
    push rdi
    push rdx
    mov rdi, str3
    call dbgPuts
    mov rdi, str5
    call acpiGetTableBySignature
    cmp DWORD [rax+48], 0
    je .doneSmiZero
    movzx rdi, BYTE [rax+53]
    cmp BYTE [rax+52], dil
    jne .doneEnableDisable
    test BYTE [rax+64], 1
    jne .donePM1aCrtl
    mov rax, [rax+53]
    mov rdx, [rax+48]
    out dx, al
    xor rdi, rdi
    jmp .doneFadtInit
.doneSmiZero:
    mov rdi, str8
    jmp .doneFadtInit
.doneEnableDisable:
    mov rdi, str9
    jmp .doneFadtInit
.donePM1aCrtl:
    mov rdi, str10
.doneFadtInit:
    cmp rdi, 0
    je .afterPrintLast
    call dbgPrintf
.afterPrintLast:
    mov rdi, str4
    call dbgPuts
    pop rdx
    pop rdi
    ret

section .rodata
str0: db "Initializing ACPI subsystem", 0x0a, 0
str1: db "Failed to get RSDP", 0x0a, 0
str2: db "Initialized ACPI subsystem", 0x0a, 0x09, "%ld entries present", 0x0a, 0
str3: db "Loading FADT", 0x0a, 0
str4: db "Loaded FADT", 0x0a, 0
str5: db "FACP"
str6: db "Not able to find table `%.4s`", 0x0a, 0
str7: db "Loaded %.4s at 0x%lx", 0x0a, 0
str8: db "ACPI mode already enabled. SMI command port == 0", 0x0a, 0
str9: db "ACPI mode already enabled. table->AcpiEnable == table->AcpiDisable == 0", 0x0a, 0
str10: db "ACPI mode already enabled. (table->PM1aControlBlock & 1) == 1", 0x0a, 0
str11: db "ACPI table `%.4s` present", 0x0a, 0

section .bss
XSDP: resq 1
XSDT: resq 1
FADT: resq 1
tables: resq 32
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