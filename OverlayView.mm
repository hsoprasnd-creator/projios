#import "OverlayView.h"
#import "ESPManager.h"

@interface OverlayView ()
@property (nonatomic, strong) UIView *menuContainer;
@property (nonatomic, strong) UIScrollView *toggleScrollView;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, assign) BOOL menuVisible;
@end

@implementation OverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.menuVisible = NO;
        [self setupMenuButton];
        [self setupMenuContainer];
        [self setupToggles];
    }
    return self;
}

- (void)setupMenuButton {
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.frame = CGRectMake(20, 50, 50, 50);
    self.menuButton.layer.cornerRadius = 25;
    self.menuButton.backgroundColor = [[UIColor colorWithRed:0.07 green:0.04 blue:0.12 alpha:0.9] colorWithAlphaComponent:0.9];
    self.menuButton.layer.borderColor = [UIColor colorWithRed:0.66 green:0.34 blue:0.97 alpha:1.0].CGColor;
    self.menuButton.layer.borderWidth = 2.0;
    self.menuButton.layer.shadowColor = [UIColor colorWithRed:0.66 green:0.34 blue:0.97 alpha:1.0].CGColor;
    self.menuButton.layer.shadowOpacity = 0.8;
    self.menuButton.layer.shadowRadius = 5.0;
    self.menuButton.layer.shadowOffset = CGSizeZero;
    [self.menuButton setTitle:@"XO" forState:UIControlStateNormal];
    [self.menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.menuButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.menuButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.menuButton];
}

- (void)setupMenuContainer {
    self.menuContainer = [[UIView alloc] initWithFrame:CGRectMake(20, 120, 320, 400)];
    self.menuContainer.backgroundColor = [[UIColor colorWithRed:0.07 green:0.04 blue:0.12 alpha:0.85] colorWithAlphaComponent:0.85];
    self.menuContainer.layer.cornerRadius = 12;
    self.menuContainer.layer.borderColor = [UIColor colorWithRed:0.66 green:0.34 blue:0.97 alpha:1.0].CGColor;
    self.menuContainer.layer.borderWidth = 1.0;
    self.menuContainer.layer.shadowColor = [UIColor colorWithRed:0.66 green:0.34 blue:0.97 alpha:1.0].CGColor;
    self.menuContainer.layer.shadowOpacity = 0.7;
    self.menuContainer.layer.shadowRadius = 15;
    self.menuContainer.layer.shadowOffset = CGSizeZero;
    self.menuContainer.hidden = YES;
    [self addSubview:self.menuContainer];

    // Header tabs
    NSArray *tabs = @[@"HOME", @"ESP", @"MOD AIM BOT", @"MOD SKIN", @"Memory", @"SETTINGS"];
    CGFloat tabWidth = 320.0 / tabs.count;
    for (int i = 0; i < tabs.count; i++) {
        UIButton *tab = [UIButton buttonWithType:UIButtonTypeCustom];
        tab.frame = CGRectMake(i * tabWidth, 0, tabWidth, 40);
        [tab setTitle:tabs[i] forState:UIControlStateNormal];
        [tab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tab.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        if (i == 1) { // ESP active
            tab.backgroundColor = [UIColor colorWithRed:0.66 green:0.34 blue:0.97 alpha:0.5];
            tab.layer.cornerRadius = 8;
            tab.layer.masksToBounds = YES;
            tab.layer.borderWidth = 1;
            tab.layer.borderColor = [UIColor colorWithRed:0.66 green:0.34 blue:0.97 alpha:1.0].CGColor;
        }
        [self.menuContainer addSubview:tab];
    }

    // Toggle scroll area
    self.toggleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 320, 355)];
    self.toggleScrollView.backgroundColor = [UIColor clearColor];
    [self.menuContainer addSubview:self.toggleScrollView];
}

- (void)setupToggles {
    NSArray *featureNames = @[@"Line", @"Radar", @"Box", @"Health", @"Name", @"Skeleton", @"Distance", @"Weapon", @"Alert"];
    CGFloat yOffset = 10;
    CGFloat toggleHeight = 40;
    CGFloat spacing = 8;
    int columnCount = 2; // 2 columns grid
    CGFloat columnWidth = 150;

    for (int i = 0; i < featureNames.count; i++) {
        int col = i % columnCount;
        int row = i / columnCount;
        CGFloat x = col * columnWidth + 10;
        CGFloat y = row * (toggleHeight + spacing) + yOffset;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, columnWidth - 50, toggleHeight)];
        label.text = featureNames[i];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [self.toggleScrollView addSubview:label];

        UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectMake(x + columnWidth - 50, y, 51, 31)];
        toggle.onTintColor = [UIColor colorWithRed:0.13 green:0.77 blue:0.37 alpha:1.0]; // neon green
        toggle.tag = i;
        [toggle addTarget:self action:@selector(toggleChanged:) forControlEvents:UIControlEventValueChanged];
        [self.toggleScrollView addSubview:toggle];

        // Set initial state
        ESPManager *esp = [ESPManager sharedInstance];
        switch (i) {
            case 0: toggle.on = esp.drawLines; break;
            case 1: toggle.on = esp.drawRadar; break;
            case 2: toggle.on = esp.drawBox; break;
            case 3: toggle.on = esp.drawHealth; break;
            case 4: toggle.on = esp.drawName; break;
            case 5: toggle.on = esp.drawSkeleton; break;
            case 6: toggle.on = esp.drawDistance; break;
            case 7: toggle.on = esp.drawWeapon; break;
            case 8: toggle.on = esp.drawAlert; break;
            default: break;
        }
    }

    // Special section "-= SKIP BOTS =-"
    CGFloat skipY = 10 + ceil(featureNames.count / (float)columnCount) * (toggleHeight + spacing) + 20;
    UILabel *skipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, skipY, 200, 20)];
    skipLabel.text = @"-= SKIP BOTS =-";
    skipLabel.textColor = [UIColor colorWithRed:0.66 green:0.34 blue:0.97 alpha:1.0];
    skipLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.toggleScrollView addSubview:skipLabel];

    UILabel *ignoreBotLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, skipY + 30, 150, 40)];
    ignoreBotLabel.text = @"IgnoreBot";
    ignoreBotLabel.textColor = [UIColor whiteColor];
    ignoreBotLabel.font = [UIFont systemFontOfSize:14];
    [self.toggleScrollView addSubview:ignoreBotLabel];

    UISwitch *ignoreBotSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(170, skipY + 35, 51, 31)];
    ignoreBotSwitch.onTintColor = [UIColor colorWithRed:0.13 green:0.77 blue:0.37 alpha:1.0];
    ignoreBotSwitch.on = [ESPManager sharedInstance].ignoreBots;
    [ignoreBotSwitch addTarget:self action:@selector(ignoreBotToggled:) forControlEvents:UIControlEventValueChanged];
    [self.toggleScrollView addSubview:ignoreBotSwitch];

    // Developer credit
    CGFloat creditY = skipY + 90;
    UILabel *credit = [[UILabel alloc] initWithFrame:CGRectMake(10, creditY, 300, 60)];
    credit.numberOfLines = 0;
    credit.text = @"Developers:\n• @krro6\n• @iphoin1";
    credit.textColor = [UIColor colorWithRed:0.61 green:0.64 blue:0.69 alpha:1.0];
    credit.font = [UIFont systemFontOfSize:12];
    [self.toggleScrollView addSubview:credit];

    self.toggleScrollView.contentSize = CGSizeMake(320, creditY + 80);
}

- (void)toggleMenu {
    self.menuVisible = !self.menuVisible;
    self.menuContainer.hidden = !self.menuVisible;
    self.userInteractionEnabled = self.menuVisible; // when menu hidden, pass touches to game
}

- (BOOL)isMenuVisible {
    return self.menuVisible;
}

- (void)toggleChanged:(UISwitch *)sender {
    ESPManager *esp = [ESPManager sharedInstance];
    switch (sender.tag) {
        case 0: esp.drawLines = sender.on; break;
        case 1: esp.drawRadar = sender.on; break;
        case 2: esp.drawBox = sender.on; break;
        case 3: esp.drawHealth = sender.on; break;
        case 4: esp.drawName = sender.on; break;
        case 5: esp.drawSkeleton = sender.on; break;
        case 6: esp.drawDistance = sender.on; break;
        case 7: esp.drawWeapon = sender.on; break;
        case 8: esp.drawAlert = sender.on; break;
        default: break;
    }
}

- (void)ignoreBotToggled:(UISwitch *)sender {
    [ESPManager sharedInstance].ignoreBots = sender.on;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.menuVisible) {
        // If menu hidden, don't capture touches
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

// Override drawRect to draw ESP lines/boxes
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (![ESPManager sharedInstance].espEnabled) return;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.66 green:0.34 blue:0.97 alpha:1.0].CGColor);

    NSArray<NSValue *> *points = [[ESPManager sharedInstance] getScreenPoints];
    CGPoint screenCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);

    for (NSValue *pointValue in points) {
        CGPoint p = [pointValue CGPointValue];

        if ([ESPManager sharedInstance].drawLines) {
            CGContextMoveToPoint(context, screenCenter.x, screenCenter.y);
            CGContextAddLineToPoint(context, p.x, p.y);
            CGContextStrokePath(context);
        }

        if ([ESPManager sharedInstance].drawBox) {
            CGRect box = CGRectMake(p.x - 15, p.y - 30, 30, 60);
            CGContextStrokeRect(context, box);
        }

        if ([ESPManager sharedInstance].drawHealth) {
            // Draw health bar placeholder
            CGRect healthBar = CGRectMake(p.x - 20, p.y - 40, 40, 4);
            CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.13 green:0.77 blue:0.37 alpha:1.0].CGColor);
            CGContextFillRect(context, healthBar);
        }

        if ([ESPManager sharedInstance].drawName) {
            NSString *name = @"Enemy";
            [name drawAtPoint:CGPointMake(p.x - 10, p.y - 50) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:[UIColor whiteColor]}];
        }
    }
}

@end