bits 16
org 0x7C00

start:
    mov si, msg
.print_loop:
    lodsb
    cmp al, 0
    je .print_done
    mov ah, 0x0E
    int 0x10
    jmp .print_loop
.print_done:

    call enable_a20

    call protected_start

    hlt
    jmp $

enable_a20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

protected_start:
    cli

    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:init_pm


bits 32
VGA_BUF_ADR equ 0xB8000
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov ebp, 0x90000
    mov esp, ebp

    mov byte [VGA_BUF_ADR], 'X'
    mov byte [VGA_BUF_ADR + 1], 0x0F
    hlt
    jmp $

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

gdt_start:

gdt_null:
    dd 0
    dd 0

gdt_code:
    dw 0xFFFF
    dw 0
    db 0
    db 10011010b
    db 11001111b
    db 0

gdt_data:
    dw 0xFFFF
    dw 0
    db 0
    db 10010010b
    db 11001111b
    db 0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

msg db "Hello from bootloader", 0

times 510 - ($ - $$) db 0
dw 0xAA55
