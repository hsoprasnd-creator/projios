#import <UIKit/UIKit.h>
#import "OverlayView.h"
#import "ESPManager.h"

%hook UIApplication

- (void)_run {
    %orig;
    // Wait for main window
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
        if (!mainWindow) return;

        OverlayView *overlay = [[OverlayView alloc] initWithFrame:mainWindow.bounds];
        overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [mainWindow addSubview:overlay];

        [[ESPManager sharedInstance] startESP];
    });
}

%end