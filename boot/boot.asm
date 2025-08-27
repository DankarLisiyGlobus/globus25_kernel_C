bits 32
section .multiboot
    dd 0x1BADB002    ; Magic
    dd 0x00000003    ; Flags
    dd -(0x1BADB002 + 0x00000003) ; Checksum

section .text
global start
extern kernel_main

start:
    mov esp, stack_top
    call kernel_main
    hlt

section .bss
stack_bottom: resb 16384
stack_top:
