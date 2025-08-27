; kernel/kernel.asm
bits 32

global load_gdt

; Функция загрузки GDT
load_gdt:
    mov eax, [esp + 4]  ; Получаем указатель на GDT
    lgdt [eax]          ; Загружаем GDT

    ; Обновляем сегментные регистры
    mov ax, 0x10        ; Селектор данных kernel
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Дальний jump для обновления CS
    jmp 0x08:.flush
.flush:
    ret


