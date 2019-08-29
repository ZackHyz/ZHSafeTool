//
//  ZHSafeToolManager.h
//  SafeToolDemo
//
//  Created by Zack on 2019/8/29.
//  Copyright © 2019 ZackHyz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define ZHSafeToolWarn(format, ...) [NSString stringWithFormat:@"***ZHSafeToolWarn*** %s %s [Line:%d] %s",__FILE__,__FUNCTION__,__LINE__,[[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]]



typedef void(^ZHSafeToolWarningObserverBlock)(NSString * warning);

@interface ZHSafeToolManager : NSObject

+ (instancetype)shareManager;
    
- (void)reportWarning: (NSString*)warning;

- (void)addWarningObserverUsingBlock:(ZHSafeToolWarningObserverBlock)block;

@end

NS_ASSUME_NONNULL_END
