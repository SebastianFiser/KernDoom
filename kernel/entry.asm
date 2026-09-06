bits 32
extern kernel_main

init_pm:
    mov ebp, 0x90000
    mov esp, ebp

    call kernel_main
    hlt
    jmp $
