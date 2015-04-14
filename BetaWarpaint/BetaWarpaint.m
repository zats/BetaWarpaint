//
//  BetaCamouflage.m
//  BetaCamouflage
//
//  Created by Sash Zats on 4/13/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

#import "BetaWarpaint.h"
#import "WMLSwizzler.h"
#import <objc/runtime.h>


static BetaWarpaint *sharedPlugin;

@interface BetaWarpaint()
@property (nonatomic, strong) NSImage *patternImage;
@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation BetaWarpaint

+ (void)pluginDidLoad:(NSBundle *)plugin {
    NSURL *receiptURL =[[NSBundle mainBundle].bundleURL URLByAppendingPathComponent:@"Contents/_MASReceipt/receipt"];
    BOOL isAppStore = [receiptURL checkResourceIsReachableAndReturnError:nil];
    if (isAppStore) {
        return;
    }
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

+ (instancetype)sharedPlugin {
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        self.bundle = plugin;
        self.patternImage = [plugin imageForResource:@"pattern"];
        [self _setupDrawSwizzling];
    }
    return self;
}

- (void)_setupDrawSwizzling {
    NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
    id class = [[[window contentView] superview] class];
    if (!class) {
        __weak id weak_self = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weak_self _setupDrawSwizzling];
        });
        return;
    }
    typedef void(*draw_rect_t)(id, NSRect);
    
    NSColor *color = [NSColor colorWithPatternImage:self.patternImage];
    __block draw_rect_t originalDrawRect = (draw_rect_t)[NSObject S_replaceMethod:@selector(drawRect:) inClass:class withImplementation:imp_implementationWithBlock(^(id self, NSRect rect){
        originalDrawRect(self, rect);
        CGContextRef context = [NSGraphicsContext currentContext].graphicsPort;
        [color setFill];
        CGContextFillRect(context, rect);
    })];
    
    NSView *something = ((NSView *)window.contentView).superview;
    [something setNeedsDisplay:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end