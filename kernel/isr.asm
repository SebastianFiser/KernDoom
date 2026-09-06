[bits 32]

global isr0
extern fault_handler

isr0:
    pusha
    call fault_handler
    popa
    iret
