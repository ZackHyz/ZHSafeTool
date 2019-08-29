//
//  UICollectionView+Exception.m
//   
//
//  Created by Zack on 2017/7/20.
//  Copyright © 2018年 ZackHyz.All rights reserved.
//

#import "UICollectionView+Exception.h"
#import "NSObject+Swizzling.h"

#ifndef DISABLE_SAFETOOL

@implementation UICollectionView (Exception)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("UICollectionView") swizzleMethod:@selector(scrollToItemAtIndexPath:atScrollPosition:animated:) swizzledSelector:@selector(replace_scrollToItemAtIndexPath:atScrollPosition:animated:)];
            
            [objc_getClass("UICollectionView") swizzleMethod:@selector(deleteItemsAtIndexPaths:) swizzledSelector:@selector(replace_deleteItemsAtIndexPaths:)];
            [objc_getClass("UICollectionView") swizzleMethod:@selector(reloadItemsAtIndexPaths:) swizzledSelector:@selector(replace_reloadItemsAtIndexPaths:)];
            
            [objc_getClass("UICollectionView") swizzleMethod:@selector(deleteSections:) swizzledSelector:@selector(replace_deleteSections:)];
            [objc_getClass("UICollectionView") swizzleMethod:@selector(reloadSections:) swizzledSelector:@selector(replace_reloadSections:)];
        }
    });
}


- (void)replace_scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated{
    if (indexPath.section >= self.numberOfSections) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return;
    }
    if (indexPath.row >= [self numberOfItemsInSection:indexPath.section]) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return;
    }
    return [self replace_scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

-(NSArray<NSIndexPath *> *)validIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    NSMutableArray *tempIndexPaths = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *index in indexPaths) {
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:index];
        if (cell) {
            [tempIndexPaths addObject:index];
        } else {
            [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        }
    }
    return tempIndexPaths;
}

-(void)replace_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    NSArray *tempIndexPaths = [self validIndexPaths:indexPaths];
    if (tempIndexPaths.count>0) {
        return [self replace_deleteItemsAtIndexPaths:tempIndexPaths];
    }
}

-(void)replace_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    NSArray *tempIndexPaths = [self validIndexPaths:indexPaths];
    if (tempIndexPaths.count>0) {
        return [self replace_reloadItemsAtIndexPaths:tempIndexPaths];
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
-(void)replace_deleteSections:(NSIndexSet *)sections{
    NSIndexSet *tempSections = [self validSetion:sections];
    if (tempSections.count>0) {
        return [self replace_deleteSections:tempSections];
    }
}

-(void)replace_reloadSections:(NSIndexSet *)sections{
    NSIndexSet *tempSections = [self validSetion:sections];
    if (tempSections.count>0){
        return [self replace_reloadSections:tempSections];
    }
}


@end


#endif
