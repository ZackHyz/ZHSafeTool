//
//  NSObject+Exception.m
//   
//
//  Created by Zack on 2018/1/8.
//  Copyright © 2018年 ZackHyz.All rights reserved.
//

#import "NSObject+Exception.h"
#import "NSObject+Swizzling.h"

#ifndef DISABLE_SAFETOOL


@interface FakeForwardTargetObject : NSObject

- (instancetype)initWithSelector:(SEL)aSelector;

@end

id fakeIMP(id sender,SEL sel,...){
    return nil;
}

@implementation FakeForwardTargetObject

- (instancetype)initWithSelector:(SEL)aSelector
{
    if (self = [super init]) {
        if(class_addMethod([self class], aSelector, (IMP)fakeIMP, NULL)) {
//            NSLog(@"add Fake Selector:[instance %@]", NSStringFromSelector(aSelector));
        }
    }
    return self;
}

@end




@implementation NSObject (Exception)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
           [objc_getClass("NSObject") swizzleMethod:@selector(forwardingTargetForSelector:) swizzledSelector:@selector(replace_forwardingTargetForSelector:)];
            
        }
    });
}

- (id)replace_forwardingTargetForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    if ([self respondsToSelector:aSelector] || signature) {
        return [self replace_forwardingTargetForSelector:aSelector];
    }
    
    return [NSObject createFakeForwardTargetObject:self selector:aSelector];

}

+ (id)createFakeForwardTargetObject:(id)aTarget selector:(SEL)aSelector
{
    if ([[NSString string] respondsToSelector:aSelector]) {
        NSString *szTarget = nil;
        if ([aTarget isKindOfClass:[NSNumber class]]) {
            szTarget = [NSString stringWithFormat:@"%@", aTarget];
        }
        
        if (szTarget) {
            return szTarget;
        }
    }
    [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"[%@] add Fake Selector [%@]",NSStringFromClass([aTarget class]), NSStringFromSelector(aSelector))];
    FakeForwardTargetObject *fakeTaget = [[FakeForwardTargetObject alloc] initWithSelector:aSelector];
    return fakeTaget;
}


@end

#endif
