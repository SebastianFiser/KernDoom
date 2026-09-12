bits 16
org 0x7C00
extern kernel_main

start:
    mov [boot_drive], dl
    mov si, msg
    call print_string

    call enable_a20
    call load_kernel
    call set_video_mode
    call protected_start

    hlt
    jmp $

print_string:
    lodsb
    cmp al, 0
    je print_done
    mov ah, 0x0E
    int 0x10
    jmp print_string
print_done:
    ret

enable_a20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

load_kernel:
    mov ax, 0x1000
    mov es, ax
    mov bx, 0x0
    mov ah, 0x02
    mov al, 20
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    int 0x13
    jc disk_error
    ret

disk_error:
    mov si, disk_error_msg
    call print_string
    hlt
    jmp $

disk_error_msg:
    db "Disk error", 0

set_video_mode:
    mov ah, 0x00
    mov al, 0x13
    int 0x10
    ret

protected_start:
    cli

    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax


    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp CODE_SEG:0x10000


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

boot_drive:
    db 0

msg db "Hello from bootloader", 0

times 510 - ($ - $$) db 0
dw 0xAA55
