[bits 32]

global isr0
extern fault_handler

global irq0
extern irq0_handler

global irq1
extern irq1_handler

isr0:
    pusha
    call fault_handler
    popa
    iret

irq0:
    pusha
    call irq0_handler
    popa
    iret

irq1:
    pusha
    call irq1_handler
    popa
    iret
