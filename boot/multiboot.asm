section .multiboot
align 4

mb_header_start:
    dd 0x1BADB002              ; magic number
    dd 0x00000003              ; flags: align + meminfo + console
    dd -(0x1BADB002 + 0x00000003) ; checksum
