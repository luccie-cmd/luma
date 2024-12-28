global KernelMain
extern dbgPrintf
extern halEarlyInit
extern halMidInit
extern acpiInit
extern acpiPrintTableSignatures
extern abort
section .text
KernelMain:
    call halEarlyInit
    call acpiInit
    call acpiPrintTableSignatures
    ; call halMidInit

    mov rdi, str4
    call dbgPrintf
    call abort 

section .rodata
str0: db "Setting up system calls (int 0x80 and syscall)", 0x0a, 0
str1: db "Mounting /boot", 0x0a, 0
str2: db "Mounting /", 0x0a, 0
str3: db "Executing /boot/init.elf", 0x0a, 0
str4: db "ERROR: /boot/init.elf returned!!!", 0x0a, 0