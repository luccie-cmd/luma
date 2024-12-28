global halInitIRQ
extern abort
extern dbgPuts
section .text
halInitIRQ:
    mov rdi, str0
    call dbgPuts
    call abort

section .rodata
str0: db "TODO: Initialize PIC/APIC/IOAPIC/LAPIC", 0x0a, 0