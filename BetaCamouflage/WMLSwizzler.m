//
//  WMLSwizzler.m
//  Wondermall
//
//  Created by Sash Zats on 1/22/15.
//  Copyright (c) 2015 Wondermall Inc. All rights reserved.
//

#import "WMLSwizzler.h"

#import <objc/runtime.h>

@implementation NSObject (Swizzler)

+ (IMP)S_replaceInstanceMethod:(SEL)originalSelector withBlock:(id)block {
    IMP implementation = imp_implementationWithBlock(block);
    return [self S_replaceInstanceMethod:originalSelector withImplementation:implementation];
}

+ (IMP)S_replaceInstanceMethod:(SEL)originalSelector withImplementation:(IMP)implementation {
    Class cls = self;
    return [self S_replaceMethod:originalSelector inClass:cls withImplementation:implementation];
    
}

+ (IMP)S_replaceClassMethod:(SEL)originalSelector withBlock:(id)block {
    IMP implementation = imp_implementationWithBlock(block);
    return [self S_replaceClassMethod:originalSelector withImplementation:implementation];
}

+ (IMP)S_replaceClassMethod:(SEL)originalSelector withImplementation:(IMP)implementation {
    Class cls = object_getClass(self);
    return [self S_replaceMethod:originalSelector inClass:cls withImplementation:implementation];
}

#pragma mark - Private

+ (IMP)S_replaceMethod:(SEL)originalSelector inClass:(Class)cls withImplementation:(IMP)newIMP {
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    IMP originalIMP = method_getImplementation(originalMethod);
    const char *originalMethodEncoding = method_getTypeEncoding(originalMethod);
    class_replaceMethod(cls, originalSelector, newIMP, originalMethodEncoding);
    return originalIMP;
}

@end
