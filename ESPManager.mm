#import "ESPManager.h"
#import "MemoryUtils.h"
#import <vector>

uintptr_t g_BaseAddress = 0;

@implementation ESPManager {
    CADisplayLink *displayLink;
    UIView *espOverlayView;
    NSMutableArray<NSValue *> *screenPoints; // store screen positions for drawing
}

+ (instancetype)sharedInstance {
    static ESPManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        g_BaseAddress = getBaseAddress();
        // Default settings
        _espEnabled = YES;
        _drawLines = YES;
        _drawBox = YES;
        _drawRadar = NO;
        _drawHealth = NO;
        _drawName = NO;
        _drawSkeleton = NO;
        _drawDistance = NO;
        _drawWeapon = NO;
        _drawAlert = NO;
        _ignoreBots = NO;
        screenPoints = [NSMutableArray array];
    }
    return self;
}

- (void)startESP {
    if (displayLink) return;
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateESP)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopESP {
    [displayLink invalidate];
    displayLink = nil;
}

- (void)updateESP {
    if (!self.espEnabled) return;
    [self readActorsAndDraw];
}

- (void)readActorsAndDraw {
    // Get GWorld
    uintptr_t gworld = readPtr(g_BaseAddress + OFFSET_GWORLD);
    if (!gworld) return;

    // Get PersistentLevel
    uintptr_t level = readPtr(gworld + OFFSET_PERSISTENTLEVEL);
    if (!level) return;

    // Get ActorList (TArray)
    TArray actorArray = readMemory<TArray>(level + OFFSET_ACTORLIST);
    if (actorArray.Count == 0 || actorArray.Data == 0) return;

    // Clear previous points
    [screenPoints removeAllObjects];

    // Get screen size
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGPoint screenCenter = CGPointMake(screenSize.width/2, screenSize.height/2);

    // Function pointer for projection
    typedef bool (*ProjectWorldLocationToScreen_t)(uintptr_t, FVector, FVector2D*, bool);
    ProjectWorldLocationToScreen_t projectFunc = (ProjectWorldLocationToScreen_t)(g_BaseAddress + OFFSET_PROJECTWORLD);

    // Iterate actors
    for (uint32_t i = 0; i < actorArray.Count; i++) {
        uintptr_t actor = readPtr(actorArray.Data + i * sizeof(uintptr_t));
        if (!actor) continue;

        // Get RootComponent
        uintptr_t rootComp = readPtr(actor + OFFSET_ROOTCOMPONENT);
        if (!rootComp) continue;

        // Get RelativeLocation
        FVector worldPos = readMemory<FVector>(rootComp + OFFSET_RELATIVELOCATION);

        // Project to screen
        FVector2D screenPos;
        bool success = projectFunc(gworld, worldPos, &screenPos, false);
        if (!success) continue;

        // Check if on screen (roughly)
        if (screenPos.X < 0 || screenPos.X > screenSize.width || screenPos.Y < 0 || screenPos.Y > screenSize.height)
            continue;

        // Store screen point for drawing
        [screenPoints addObject:[NSValue valueWithCGPoint:CGPointMake(screenPos.X, screenPos.Y)]];
    }

    // Trigger drawing on overlay
    if (espOverlayView) {
        [espOverlayView setNeedsDisplay];
    }
}

// This method will be called from OverlayView's drawRect to get points
- (NSArray<NSValue *> *)getScreenPoints {
    return screenPoints;
}

@end