//
//  NSObject+Swizzling.h
//   
//
//  Created by Zack on 2017/6/21.
//  Copyright © 2018年 ZackHyz.All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Swizzling)

+ (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
