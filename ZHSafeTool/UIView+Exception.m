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
            [objc_getClass("UIView") swizzleMethod:@selector(setFrame:) swizzledSelector:@selector(replace_setFrame:)];
            [objc_getClass("UIView") swizzleMethod:@selector(initWithFrame:) swizzledSelector:@selector(replace_initWithFrame:)];

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

-(BOOL)isFrameInvalid:(CGRect)frame
{
    if (frame.origin.x == INFINITY||frame.origin.x == -INFINITY||isnan(frame.origin.x)  ||
        frame.origin.y == INFINITY||frame.origin.y == -INFINITY||isnan(frame.origin.y) ||
        frame.size.width == INFINITY||frame.size.width <0 || isnan(frame.size.width) ||
        frame.size.height == INFINITY||frame.size.height <0 || isnan(frame.size.height)) {
        return YES;
    }
    return NO;
}
-(void)replace_setFrame:(CGRect)frame{
    
    if ([self isFrameInvalid:frame]) {
        return [self replace_setFrame:CGRectZero];
    }
    return [self replace_setFrame:frame];
}

-(instancetype)replace_initWithFrame:(CGRect)frame
{
    if ([self isFrameInvalid:frame]) {
        return [self replace_initWithFrame:CGRectZero];
    }
    return  [self replace_initWithFrame:frame];
}

@end
