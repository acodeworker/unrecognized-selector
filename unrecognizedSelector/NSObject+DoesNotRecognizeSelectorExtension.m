//
//  NSObject+DoesNotRecognizeSelectorExtension.m
//  01-Runtime 初探
//
//  Created by zmodo on 2019/8/14.
//  Copyright © 2019 JeremyLu. All rights reserved.
//

#import "NSObject+DoesNotRecognizeSelectorExtension.h"
#import <objc/runtime.h>
#import "ForwardingTarget.h"

static ForwardingTarget *_target = nil;

@implementation NSObject (DoesNotRecognizeSelectorExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _target = [ForwardingTarget new];;
        //交换实例方法
        not_recognize_selector_classMethodSwizzle([self class], @selector(forwardingTargetForSelector:), @selector(doesnot_recognize_selector_swizzleForwardingTargetForSelector:));
        
        //交换类方法
         not_recognize_selector_classMethodSwizzle(object_getClass([self class]), @selector(forwardingTargetForSelector:), @selector(doesnot_recognize_selector_swizzleForwardingTargetForSelector:));
    });
}


/*如果只想要拦截特定的几个类的崩溃，可以在这里加一个白名单，这样其他的崩溃就不会拦截*/

+ (BOOL)isWhiteListClass:(Class)class {
    
    NSString *classString = NSStringFromClass(class);
    BOOL isInternal = [classString hasPrefix:@"_"];
    if (isInternal) {
        return NO;
    }
    BOOL isNull =  [classString isEqualToString:NSStringFromClass([NSNull class])];
     BOOL isMyClass  = [classString isEqualToString:@"LGPerson"];
    return isNull || isMyClass;
//    return isNull;
}

 #pragma mark - 实例方法消息转发

- (id)doesnot_recognize_selector_swizzleForwardingTargetForSelector:(SEL)aSelector {
    id result = [self doesnot_recognize_selector_swizzleForwardingTargetForSelector:aSelector];
    if (result) {
        return result;
    }
    BOOL isWhiteListClass = [[self class] isWhiteListClass:[self class]];
    if (!isWhiteListClass) {
        return nil;
    }
    
    if (!result) {
        result = _target;
        NSLog(@"- %@ unrecognized selector:%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector));

    }
    return result;
}

#pragma mark - 类方法消息转发

+ (id)doesnot_recognize_selector_swizzleForwardingTargetForSelector:(SEL)aSelector {
    id result = [self doesnot_recognize_selector_swizzleForwardingTargetForSelector:aSelector];
    if (result) {
        return result;
    }
    BOOL isWhiteListClass = [[self class] isWhiteListClass:[self class]];
    if (!isWhiteListClass) {
        return nil;
    }
    
    if (!result) {
        result = _target;
        /***
         +[LGPerson doingCrash]: unrecognized selector
         */
        NSLog(@"+ %@ unrecognized selector:%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector));

    }
    return result;
}



#pragma mark - private method

BOOL not_recognize_selector_classMethodSwizzle(Class aClass, SEL originalSelector, SEL swizzleSelector) {
    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(aClass, swizzleSelector);
    BOOL didAddMethod =
    class_addMethod(aClass,
                    originalSelector,
                    method_getImplementation(swizzleMethod),
                    method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(aClass,
                            swizzleSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
    return YES;
}

@end
