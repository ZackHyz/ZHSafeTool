//
//  NSDictionary+Exception.m
//  CrashDemo
//
//  Created by Zack on 2017/6/22.
//  Copyright © 2018年 ZackHyz.. All rights reserved.
//

#import "NSDictionary+Exception.h"
#import "NSObject+Swizzling.h"

#ifndef DISABLE_SAFETOOL

@implementation NSDictionary (Exception)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSPlaceholderDictionary") swizzleMethod:@selector(initWithObjects:forKeys:count:) swizzledSelector:@selector(replace_initWithObjects:forKeys:count:)];
            [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(replace_setObject:forKey:)];
            [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(removeObjectForKey:) swizzledSelector:@selector(replace_removeObjectForKey:)];
        }
    });
}

- (instancetype)replace_initWithObjects:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)count{
    NSUInteger rightCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (!(keys[i] && objects[i])) {
            [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
            break;
        }else{
            rightCount++;
        }
    }
    return [self replace_initWithObjects:objects forKeys:keys count:rightCount];
}

- (void)replace_setObject:(id)object forKey:(id<NSCopying>)key{
    if ((!object) || (!key)) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
      return;
    }
    return [self replace_setObject:object forKey:key];
}

- (void)replace_removeObjectForKey:(id)key{
    if (!key) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return;
    }
    return [self replace_removeObjectForKey:key];
}

@end

#endif
