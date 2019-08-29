//
//  NSMutableString+Exception.m
//  CrashDemo
//
//  Created by Zack on 2017/6/22.
//  Copyright © 2018年 ZackHyz.. All rights reserved.
//

#import "NSMutableString+Exception.h"
#import "NSObject+Swizzling.h"

#ifndef DISABLE_SAFETOOL

@implementation NSMutableString (Exception)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSCFString") swizzleMethod:@selector(substringFromIndex:) swizzledSelector:@selector(replace_substringFromIndex:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(substringToIndex:) swizzledSelector:@selector(replace_substringToIndex:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(substringWithRange:) swizzledSelector:@selector(replace_substringWithRange:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(rangeOfString:options:range:locale:) swizzledSelector:@selector(replace_rangeOfString:options:range:locale:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(replaceCharactersInRange:withString:) swizzledSelector:@selector(replace_replaceCharactersInRange:withString:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(insertString:atIndex:) swizzledSelector:@selector(replace_insertString:atIndex:)];

            [objc_getClass("__NSCFString") swizzleMethod:@selector(objectForKeyedSubscript:) swizzledSelector:@selector(replace_objectForKeyedSubscript:)];
        }
    });
}

- (NSString*)replace_substringFromIndex:(NSInteger)from{
    // 保证有数据返回
    NSUInteger fromIndex = MIN(self.length, from);
    return [self replace_substringFromIndex:fromIndex];
    
}
- (NSString*)replace_substringToIndex:(NSUInteger)to {
    // 保证有数据返回
    NSUInteger toIndex = MIN(self.length, to);
    return [self replace_substringToIndex:toIndex];
}

- (NSString *)replace_substringWithRange:(NSRange)range{
    if (range.location > self.length) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return nil;
    }
    if (range.length > self.length) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return nil;
    }
    if ((range.location + range.length) > self.length) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return nil;
    }
    return [self replace_substringWithRange:range];
}

- (NSRange)replace_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(nullable NSLocale *)locale{
    if (!searchString) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return NSMakeRange(0, 0);
    }
    if ((rangeOfReceiverToSearch.location + rangeOfReceiverToSearch.length) > self.length) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return NSMakeRange(0, 0);
    }
    return [self replace_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}


- (void)replace_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString{
    if (range.location > self.length) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return ;
    }
    if (range.length > self.length) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return ;
    }
    if ((range.location + range.length) > self.length) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return ;
    }
    if (!aString) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return;
    }
    return [self replace_replaceCharactersInRange:range withString:aString];
}

- (void)replace_insertString:(NSString *)aString atIndex:(NSInteger)loc{
    if(loc<0||loc>self.length){
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return;
    }
    return [self replace_insertString:aString atIndex:loc];
}

- (id)replace_objectForKeyedSubscript:(NSString *)key {
    [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
    return nil;
}


@end

#endif
