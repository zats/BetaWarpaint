//
//  BetaCamouflage.h
//  BetaCamouflage
//
//  Created by Sash Zats on 4/13/15.
//  Copyright (c) 2015 Sash Zats. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface BetaCamouflage : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end