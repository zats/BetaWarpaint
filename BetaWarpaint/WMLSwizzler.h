//
//  WMLSwizzler.h
//  Wondermall
//
//  Created by Sash Zats on 1/22/15.
//  Copyright (c) 2015 Wondermall Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzler)

+ (IMP)S_replaceInstanceMethod:(SEL)originalSelector withBlock:(id)block;

+ (IMP)S_replaceClassMethod:(SEL)originalSelector withBlock:(id)block;

+ (IMP)S_replaceInstanceMethod:(SEL)originalSelector withImplementation:(IMP)implementation;

+ (IMP)S_replaceClassMethod:(SEL)originalSelector withImplementation:(IMP)implementation;

+ (IMP)S_replaceMethod:(SEL)originalSelector inClass:(Class)cls withImplementation:(IMP)newIMP;

@end
