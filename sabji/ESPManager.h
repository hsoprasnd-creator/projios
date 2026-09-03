#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Config.h"

@interface ESPManager : NSObject

+ (instancetype)sharedInstance;

- (void)startESP;
- (void)stopESP;
- (void)updateESP;

@property (nonatomic, assign) BOOL espEnabled;
@property (nonatomic, assign) BOOL drawLines;
@property (nonatomic, assign) BOOL drawBox;
@property (nonatomic, assign) BOOL drawRadar;
@property (nonatomic, assign) BOOL drawHealth;
@property (nonatomic, assign) BOOL drawName;
@property (nonatomic, assign) BOOL drawSkeleton;
@property (nonatomic, assign) BOOL drawDistance;
@property (nonatomic, assign) BOOL drawWeapon;
@property (nonatomic, assign) BOOL drawAlert;
@property (nonatomic, assign) BOOL ignoreBots;

@end