//
//  NSMutableArray+Exception.m
//  CrashDemo
//
//  Created by Zack on 2017/6/22.
//  Copyright © 2018年 ZackHyz.. All rights reserved.
//

#import "NSMutableArray+Exception.h"
#import "NSObject+Swizzling.h"

@implementation NSMutableArray (Exception)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(replace_objectAtIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(insertObject:atIndex:) swizzledSelector:@selector(replace_insertObject:atIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(setObject:atIndexedSubscript:) swizzledSelector:@selector(replace_setObject:atIndexedSubscript:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(replaceObjectAtIndex:withObject:) swizzledSelector:@selector(replace_replaceObjectAtIndex:withObject:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(removeObjectAtIndex:) swizzledSelector:@selector(replace_removeObjectAtIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(removeObjectsInRange:) swizzledSelector:@selector(replace_removeObjectsInRange:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(removeObject:inRange:) swizzledSelector:@selector(replace_removeObject:inRange:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(replace_objectAtIndexedSubscript:)];
        }
    });
}

- (id)replace_objectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self replace_objectAtIndex:index];
}

- (void)replace_insertObject:(id)object atIndex:(NSInteger)index{
    if (index > self.count || index < 0) {
        return ;
    }
    if (!object) {
        return;
    }
    return [self replace_insertObject:object atIndex:index];
}

- (void)replace_setObject:(id)object atIndexedSubscript:(NSInteger)index{
    if (index > self.count || index < 0) {
        return ;
    }
    if (!object) {
        return;
    }
    return [self replace_setObject:object atIndexedSubscript:index];
}

- (void)replace_replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject{
    if (index >= self.count || index < 0) {
        return ;
    }
    if (!anObject) {
        return;
    }
    return [self replace_replaceObjectAtIndex:index withObject:anObject];
}


- (void)replace_removeObjectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return ;
    }
    return [self replace_removeObjectAtIndex:index];
}

- (void)replace_removeObjectsInRange:(NSRange)range {
    if (range.location > self.count) {
        return;
    }
    if (range.length > self.count) {
        return;
    }
    if ((range.location + range.length) > self.count) {
        return;
    }
    return [self replace_removeObjectsInRange:range];
}

- (void)replace_removeObject:(id)anObject inRange:(NSRange)range{
    if (range.location > self.count) {
        return;
    }
    if (range.length > self.count) {
        return;
    }
    if ((range.location + range.length) > self.count) {
        return;
    }
    if (!anObject){
        return;
    }
    return [self replace_removeObject:anObject inRange:range];
}

- (id)replace_objectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {    
        return nil;
    }
    return [self replace_objectAtIndexedSubscript:index];
}

@end
