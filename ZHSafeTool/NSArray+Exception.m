//
//  NSArray+Exception.m
//  CrashDemo
//
//  Created by Zack on 2017/6/22.
//  Copyright © 2018年 ZackHyz.. All rights reserved.
//

#import "NSArray+Exception.h"
#import "NSObject+Swizzling.h"

#ifndef DISABLE_SAFETOOL
@implementation NSArray (Exception)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(replace_NSArray0_ObjectAtIndex:)];
            [objc_getClass("__NSSingleObjectArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(replace_NSSingleObjectArrayI_objectAtIndex:)];
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(replace_NSArrayI_objectAtIndex:)];
            
            
            [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(replace_NSArray0_objectAtIndexedSubscript:)];
            [objc_getClass("__NSSingleObjectArrayI") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(replace_NSSingleObjectArrayI_objectAtIndexedSubscript:)];
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(replace_NSArrayI_objectAtIndexedSubscript:)];
            
            
            [objc_getClass("__NSArray0") swizzleMethod:@selector(subarrayWithRange:) swizzledSelector:@selector(replace_NSArray0_subarrayWithRange:)];
            [objc_getClass("__NSSingleObjectArrayI") swizzleMethod:@selector(subarrayWithRange:) swizzledSelector:@selector(replace_NSSingleObjectArrayI_subarrayWithRange:)];
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(subarrayWithRange:) swizzledSelector:@selector(replace_NSArrayI_subarrayWithRange:)];
        }
    });
}

- (id)replace_NSArray0_ObjectAtIndex:(NSInteger)index{
    [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];;
    return nil;
}

- (id)replace_NSSingleObjectArrayI_objectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];;
        return nil;
    }
    return [self replace_NSSingleObjectArrayI_objectAtIndex:index];
}
- (id)replace_NSArrayI_objectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];;
        return nil;
    }
    return [self replace_NSArrayI_objectAtIndex:index];
}

-(id)replace_NSArray0_objectAtIndexedSubscript:(NSUInteger)index{
    [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];;
    return nil;
}

-(id)replace_NSSingleObjectArrayI_objectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
    [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];;
        return nil;
    }
    return [self replace_NSSingleObjectArrayI_objectAtIndexedSubscript:index];
}

-(id)replace_NSArrayI_objectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
    [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];;
        return nil;
    }
    return [self replace_NSArrayI_objectAtIndexedSubscript:index];
}
    
- (NSArray<id> *)replace_NSArray0_subarrayWithRange:(NSRange)range {
    return nil;
}
    
- (NSArray<id> *)replace_NSSingleObjectArrayI_subarrayWithRange:(NSRange)range {
    NSRange newRange = range;
    if (range.location < 0) {
        newRange.location = 0;
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];;
    }
    if (newRange.location + newRange.length > self.count) {
        newRange.length = self.count - newRange.location;
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];;
    }
    return [self replace_NSSingleObjectArrayI_subarrayWithRange:newRange];
}

- (NSArray<id> *)replace_NSArrayI_subarrayWithRange:(NSRange)range {
    NSRange newRange = range;
    if (range.location < 0) {
        newRange.location = 0;
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];;
    }
    if (newRange.location + newRange.length > self.count) {
        newRange.length = self.count - newRange.location;
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];;
    }
    return [self replace_NSArrayI_subarrayWithRange:newRange];
}


@end

#endif
