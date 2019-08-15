//
//  ForwardingTarget.m
//  01-Runtime 初探
//
//  Created by zmodo on 2019/8/14.
//  Copyright © 2019 JeremyLu. All rights reserved.
//

#import "ForwardingTarget.h"
#import <objc/runtime.h>

@implementation ForwardingTarget

id ForwardingTarget_dynamicMethod(id self, SEL _cmd) {
    return [NSNull null];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    class_addMethod(self.class, sel, (IMP)ForwardingTarget_dynamicMethod, "@@:");
    [super resolveInstanceMethod:sel];
    return YES;
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    class_addMethod(object_getClass([self class]), sel, (IMP)ForwardingTarget_dynamicMethod, "@@:");
    [super resolveClassMethod:sel];
    return YES;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    id result = [super forwardingTargetForSelector:aSelector];
    return result;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    id result = [super methodSignatureForSelector:aSelector];
    return result;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [super forwardInvocation:anInvocation];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector]; // crash
}

@end
