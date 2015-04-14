//
//  BetaWarPaint.m
//  BetaWarPaint
//
//  Created by Sash Zats on 4/13/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

#import "BetaWarPaint.h"
#import "WMLSwizzler.h"
#import <objc/runtime.h>


static BetaWarPaint *sharedPlugin;


@interface BetaWarPaint()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end


@implementation BetaWarPaint

+ (void)pluginDidLoad:(NSBundle *)plugin {
    NSLog(@"BetaWarPaint");
    NSURL *receiptURL =[[NSBundle mainBundle].bundleURL URLByAppendingPathComponent:@"Contents/_MASReceipt/receipt"];
    BOOL isAppStore = [receiptURL checkResourceIsReachableAndReturnError:nil];
    if (isAppStore) {
        return;
    }
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
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
        [self _setupDrawSwizzling];
    }
    return self;
}

- (void)_setupDrawSwizzling {
    NSLog(@"BetaWarPaint swizzling");
    NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
    id class = [[[window contentView] superview] class];
    typedef void(*draw_rect_t)(id, NSRect);
    __block draw_rect_t originalDrawRect = (draw_rect_t)[NSObject S_replaceMethod:@selector(drawRect:) inClass:class withImplementation:imp_implementationWithBlock(^(id self, NSRect rect){
        originalDrawRect(self, rect);
        CGContextRef context = [[NSGraphicsContext currentContext]graphicsPort];
        [[NSColor redColor] setFill];
        CGContextFillRect(context, rect);
    })];
    
    [((NSView *)window.contentView).superview setNeedsDisplay:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
