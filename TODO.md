[ ] Luma
- [x] ACPI
    - [x] Load RSDP
    - [x] Load XSDT
    - [x] Init FADT
    - [x] Loading of tables by signature
- [ ] HAL
    - [ ] IDT
        - [x] Setting IDTR register
        - [ ] Exceptions handler
            - [ ] Page fault
            - [ ] Invalid Opcode
            - [ ] General Protection
        - [ ] Hardware interrupt handler
    - [x] GDT
        - [x] Setting GDTR register
    - [ ] TSS
        - [ ] Setting task register
    - [ ] VFS
        - [ ] Opening of files
        - [ ] Closing of files
        - [ ] Reading from files
        - [ ] Writing to files
        - [ ] Mounting of disk:partition
        - [ ] Mounting of files
    - [ ] IRQ
        - [ ] Load MADT table
        - [ ] Load MADT entries
            - [ ] Handle LAPIC
            - [ ] Handle IOAPIC
            - [ ] Handle IOAPIC ISO
            - [ ] Handle IOAPIC NMIS (NMI source)
            - [ ] Handle LAPIC NMI
            - [ ] Handle LAPIC Address override
            - [ ] Handle lX2APIC
- [ ] MMU
    - [ ] PMM
        - [ ] Load physical memory map
        - [ ] Allocate page
        - [ ] Free pages
    - [ ] VMM
        - [x] Make virtual addresses
        - [ ] Map page to address in specific PML
    - [ ] Heap
        - [ ] Allocate N bytes, after eachother
            - [ ] Kernel
            - [ ] User
        - [ ] Free all bytes
            - [ ] Kernel
            - [ ] User
        - [ ] Free N bytes
            - [ ] Kernel
            - [ ] User
- [ ] Syscalls
    - [ ] syscall/sysenter
    - [ ] int 0x80
    - [ ] Common
        - [ ] sys_write
        - [ ] sys_read
        - [ ] sys_open
        - [ ] sys_close
        - [ ] sys_malloc
        - [ ] sys_free
        - [ ] sys_exit
- [ ] Task Manager
    - [ ] Keep track of all processes
    - [ ] Create new process
    - [ ] Send signal to process
    - [ ] Remove process