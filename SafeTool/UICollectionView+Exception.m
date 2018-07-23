//
//  UICollectionView+Exception.m
//   
//
//  Created by Zack on 2017/7/20.
//  Copyright © 2018年 ZackHyz.All rights reserved.
//

#import "UICollectionView+Exception.h"
#import "NSObject+Swizzling.h"

@implementation UICollectionView (Exception)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("UICollectionView") swizzleMethod:@selector(scrollToItemAtIndexPath:atScrollPosition:animated:) swizzledSelector:@selector(replace_scrollToItemAtIndexPath:atScrollPosition:animated:)];
        }
    });
}


- (void)replace_scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated{
    if (indexPath.section >= self.numberOfSections) {
        return;
    }
    if (indexPath.row >= [self numberOfItemsInSection:indexPath.section]) {
        return;
    }
    return [self replace_scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}


@end
