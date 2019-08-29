//
//  NSAttributedString+Exception.m
//   
//
//  Created by Zack on 2018/5/25.
//  Copyright © 2018年 ZackHyz.All rights reserved.
//

#import "NSAttributedString+Exception.h"
#import "NSObject+Swizzling.h"

#ifndef DISABLE_SAFETOOL

@implementation NSAttributedString (Exception)


+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("NSConcreteAttributedString") swizzleMethod:@selector(initWithString:) swizzledSelector:@selector(alert_replaceInitWithString:)];
            
        }
    });
}

-(instancetype)alert_replaceInitWithString:(NSString*)aString{
    if (!aString) {
        [[ZHSafeToolManager shareManager]reportWarning:ZHSafeToolWarn(@"Exception")];
        return nil;
    }
    return [self alert_replaceInitWithString:aString];
}
@end

#endif
