#pragma once
#include <cstdint>
#include <mach/mach.h>

uintptr_t getBaseAddress();
template<typename T> T readMemory(uintptr_t address);
template<typename T> void writeMemory(uintptr_t address, T value);
uintptr_t readPtr(uintptr_t address);