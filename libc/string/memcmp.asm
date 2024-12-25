global memcmp
section .text
memcmp:
    push rdx
    push rcx
    push r8
    xor ecx, ecx
.L2:
    cmp rdx, rcx
    je .L7
    movzx eax, BYTE [rdi+rcx]
    inc rcx
    movzx r8d, BYTE [rsi-1+rcx]
    cmp al, r8b
    je .L2
    sub eax, r8d
    pop r8
    pop rcx
    pop rdx
    ret
.L7:
    xor eax, eax
    pop r8
    pop rcx
    pop rdx
    ret