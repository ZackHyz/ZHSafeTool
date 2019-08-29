//
//  UITableView+Exception.m
//  SafeToolDemo
//
//  Created by Zack on 2018/8/21.
//  Copyright © 2018年 ZackHyz. All rights reserved.
//

#import "UITableView+Exception.h"
#import "NSObject+Swizzling.h"

#ifndef DISABLE_SAFETOOL

@implementation UITableView (Exception)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("UITableView") swizzleMethod:@selector(deleteRowsAtIndexPaths:withRowAnimation:) swizzledSelector:@selector(replace_deleteRowsAtIndexPaths:withRowAnimation:)];
            [objc_getClass("UITableView") swizzleMethod:@selector(reloadRowsAtIndexPaths:withRowAnimation:) swizzledSelector:@selector(replace_reloadRowsAtIndexPaths:withRowAnimation:)];
            
            [objc_getClass("UITableView") swizzleMethod:@selector(deleteSections:withRowAnimation:) swizzledSelector:@selector(replace_deleteSections:withRowAnimation:)];
            [objc_getClass("UITableView") swizzleMethod:@selector(reloadSections:withRowAnimation:) swizzledSelector:@selector(replace_reloadSections:withRowAnimation:)];
        }
    });
}

-(NSArray<NSIndexPath *> *)validIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    
    NSMutableArray *tempIndexPaths = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *index in indexPaths) {
        UITableViewCell *cell = [self cellForRowAtIndexPath:index];
        if (cell) {
            [tempIndexPaths addObject:index];
        } else {
            [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        }
    }
    return tempIndexPaths;
}

-(void)replace_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    NSArray *tempIndexPaths = [self validIndexPaths:indexPaths];
    if (tempIndexPaths.count>0) {
        return [self replace_deleteRowsAtIndexPaths:tempIndexPaths withRowAnimation:animation];
    }
}


-(void)replace_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    NSArray *tempIndexPaths = [self validIndexPaths:indexPaths];
    if (tempIndexPaths.count>0) {
        return [self replace_reloadRowsAtIndexPaths:tempIndexPaths withRowAnimation:animation];
    }
}

-(NSIndexSet *)validSetion:(NSIndexSet *)sections{
    __block NSMutableIndexSet *tempSections = [NSMutableIndexSet new];
    __block NSInteger sectionsCount = [self numberOfSections];
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx<sectionsCount) {
            [tempSections addIndex:idx];
        } else {
            [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        }
    }];
    return tempSections;
}
-(void)replace_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    NSIndexSet *tempSections = [self validSetion:sections];
    if (tempSections.count>0) {
        return [self replace_deleteSections:tempSections withRowAnimation:animation];
    }
}

-(void)replace_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    NSIndexSet *tempSections = [self validSetion:sections];
    if (tempSections.count>0){
        return [self replace_reloadSections:tempSections withRowAnimation:animation];
    }
}
@end

#endif
