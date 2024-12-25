global KernelMain
extern dbgPrintf
extern halEarlyInit
extern acpiInit
extern abort
section .text
KernelMain:
    call halEarlyInit
    call acpiInit

    mov rdi, str5
    call dbgPrintf
    call abort 

section .rodata
str0: db "Setting up mid HAL", 0x0a, 0
str1: db "Setting up system calls (int 0x80 and syscall)", 0x0a, 0
str2: db "Mounting /boot", 0x0a, 0
str3: db "Mounting /", 0x0a, 0
str4: db "Executing /boot/init.elf", 0x0a, 0
str5: db "ERROR: /boot/init.elf returned!!!", 0x0a, 0