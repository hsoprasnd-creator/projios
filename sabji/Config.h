#pragma once
#include <cstdint>

// Base address (set at runtime)
extern uintptr_t g_BaseAddress;

// Global addresses (RVAs)
#define OFFSET_GWORLD          0x105C669C4
#define OFFSET_GNAMES          0x1041ef544
#define OFFSET_PROJECTWORLD    0x1054CE53C
#define OFFSET_BONEPOS         0x102831A9C

// World & Actor list
#define OFFSET_PERSISTENTLEVEL 0x30
#define OFFSET_ACTORLIST       0xA0

// Actor & component
#define OFFSET_ROOTCOMPONENT   0x208
#define OFFSET_RELATIVELOCATION 0x1e4

// Structs
struct FVector {
    float X, Y, Z;
};

struct FVector2D {
    float X, Y;
};

struct TArray {
    uintptr_t Data;
    uint32_t Count;
    uint32_t Max;
};