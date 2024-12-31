global halInitIRQ
global halIRQgetLapicAddr
extern abort
extern dbgPrintf
extern acpiGetTableBySignature
extern initLAPIC
extern initIOAPIC
extern initIOAPICISO
extern initIOAPICNMI
extern initLAPICNMI
extern initLAPICAO
extern initLx2APIC
section .text
halInitIRQ:
    push rdi
    mov rdi, str0
    call acpiGetTableBySignature
    mov [madt], rax
    mov edi, DWORD [rax+0x28]
    and rdi, 1
    cmp rdi, 1
    jne .afterMaskIRQ
    push WORD ax
    mov al, 0xFF
    out 0x20, al
    out 0xA0, al
    pop WORD ax
.afterMaskIRQ:
    xor rdi, rdi
    mov edi, DWORD [rax+0x04]
    mov rsi, 0x2C
    jmp .condition
.loop:
    push rdx
    push rax
    push rdi
    push r8
    push r9
    xor rdx, rdx
    add rax, rsi
    mov dx, WORD [rax]
    xor r9, r9
    mov r9w, dx
    mov r8, rax
    movzx dx, dh
    movzx rdx, dx
    add rsi, rdx
    lea rax, madtJumpTable
    and r9, 0xFF
    shl r9, 3
    add rax, r9
    ; rdi: MADT entry address
    mov rdi, r8
    call [rax]
    pop r9
    pop r8
    pop rdi
    pop rax
    pop rdx
.condition:
    cmp rsi, rdi
    jl .loop
    pop rdi
    ret

halIRQgetLapicAddr:
    xor rax, rax
    mov eax, DWORD [madt+0x24]
    ret

invalidMADTtype:
    movzx rsi, BYTE [rdi]
    mov rdi, str1
    call dbgPrintf
    call abort

section .jmpTable
global madtJumpTable
madtJumpTable:
    ; dq initIOAPIC      ; 1
    ; dq initIOAPICISO   ; 2
    ; dq initIOAPICNMI   ; 3
    ; dq initLAPICNMI    ; 4
    ; dq initLAPICAO     ; 5
    ; dq invalidMADTtype ; 6
    ; dq invalidMADTtype ; 7
    ; dq invalidMADTtype ; 8
    ; dq initLx2APIC     ; 9
    dq initLAPIC       ; 0
    dq invalidMADTtype ; 1
    dq invalidMADTtype ; 2
    dq invalidMADTtype ; 3
    dq invalidMADTtype ; 4
    dq invalidMADTtype ; 5
    dq invalidMADTtype ; 6
    dq invalidMADTtype ; 7
    dq invalidMADTtype ; 8
    dq invalidMADTtype ; 9

section .bss
madt: resq 1

section .rodata
str0: db "APIC"
str1: db "Invalid MADT entry with type %hd", 0x0a, 0