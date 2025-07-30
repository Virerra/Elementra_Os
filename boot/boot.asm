; boot.asm - Bootloader for Elementra_OS
[bits 16]
[org 0x7c00]

start:
    cli                 ; Clear interrupts
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00      ; Set up stack

    ; Load kernel (we’ll assume it’s at 1MB)
    mov si, loading_msg
    call print

    ; Switch to 32-bit Protected Mode
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE_SEG:init_pm

print:
    mov ah, 0x0e
.next:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .next
.done:
    ret

loading_msg db "Loading Elementra_OS...", 0

; GDT setup
gdt_start:
    dw 0x0000, 0x0000, 0x0000, 0x0000      ; null segment
    dw 0xffff, 0x0000, 0x9A00, 0x00CF      ; code segment
    dw 0xffff, 0x0000, 0x9200, 0x00CF      ; data segment
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ 0x08
DATA_SEG equ 0x10

[bits 32]
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x9FB00     ; stack pointer

    call kernel_main     ; call the kernel in C
.hang:
    jmp .hang

times 510 - ($ - $$) db 0
dw 0xAA55
