// power.c
#include "portio/portio.h"
#include "power.h"

void shutdown(void) {
    // Пробуем разные методы
    outw(0xB004, 0x2000);  // QEMU и некоторые реальные машины
    outw(0x604, 0x2000);   // VirtualBox и другие
    outw(0x4004, 0x3400);   // Дополнительный порт
    
    // Если не сработало - перезагрузка
    reboot();
}

void reboot(void) {
    uint8_t temp;
    
    // Через keyboard controller
    do {
        temp = inb(0x64);
        if (temp & 0x01) {
            inb(0x60);  // Сбрасываем буфер
        }
    } while (temp & 0x02);
    
    outb(0x64, 0xFE);  // Команда перезагрузки
}