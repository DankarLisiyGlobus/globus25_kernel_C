/* boot/linker.ld */
OUTPUT_FORMAT(elf32-i386)
ENTRY(start)


SECTIONS {
    /* Ядро загружается по адресу 1MB */
    . = 1M;

    /* Multiboot header должен быть в первых 8KB */
    .text BLOCK(4K) : ALIGN(4K) {
        *(.multiboot)
        *(.text)
    }

    .rodata BLOCK(4K) : ALIGN(4K) {
        *(.rodata)
    }

    .data BLOCK(4K) : ALIGN(4K) {
        *(.data)
    }

    .bss BLOCK(4K) : ALIGN(4K) {
        *(COMMON)
        *(.bss)
        *(.stack)
      }
    /* Простая область под кучу: 32 MiB сразу после .bss */
    .heap : {
      _heap_start = .;
      . = . + 32 * 1024 * 1024; /* 32 MiB */
      _heap_end = .;
    }

    /* 
    * Пространство для пользовательских (user) программ.
    * Здесь резервируем N MiB (в примере — 128 MiB) начиная сразу после кучи.
    * Каждая пользовательская задача будет получать свой кусок из этого пространства.
    */
    .user : {
        _user_start = .;
        /* 128 MiB под user-программы */
        . = . + 128 * 1024 * 1024; /* 128 MiB */
        _user_end = .;
    }

        /* Символы для определения размеров ядра */
        kernel_end = .;
    }

