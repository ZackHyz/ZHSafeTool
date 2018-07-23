//
//  UIView+Exception.m
//   
//
//  Created by Zack on 2017/11/10.
//  Copyright © 2018年 ZackHyz.All rights reserved.
//

#import "UIView+Exception.h"
#import "NSObject+Swizzling.h"

@implementation UIView (Exception)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("UIView") swizzleMethod:@selector(setNeedsLayout) swizzledSelector:@selector(replace_setNeedsLayout)];
            [objc_getClass("UIView") swizzleMethod:@selector(setNeedsDisplay) swizzledSelector:@selector(replace_setNeedsDisplay)];

        }
    });
}

-(void)replace_setNeedsLayout{
    if ([NSThread isMainThread]) {
        return [self replace_setNeedsLayout];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            return [self replace_setNeedsLayout];
        });
    }
}

-(void)replace_setNeedsDisplay{
    if ([NSThread isMainThread]) {
        return [self replace_setNeedsDisplay];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            return [self replace_setNeedsDisplay];
        });
    }
}

@end
