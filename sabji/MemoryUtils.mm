#import "MemoryUtils.h"
#import <dlfcn.h>
#import <mach-o/dyld.h>

uintptr_t getBaseAddress() {
    // Get base address of main executable (image index 0)
    const struct mach_header *header = _dyld_get_image_header(0);
    return (uintptr_t)header;
}

template<typename T>
T readMemory(uintptr_t address) {
    T value;
    vm_size_t size = sizeof(T);
    vm_read_overwrite(mach_task_self(), (vm_address_t)address, size, (vm_address_t)&value, &size);
    return value;
}

template<typename T>
void writeMemory(uintptr_t address, T value) {
    vm_write(mach_task_self(), (vm_address_t)address, (vm_offset_t)&value, sizeof(T));
}

uintptr_t readPtr(uintptr_t address) {
    return readMemory<uintptr_t>(address);
}