//
//  ZHSafeToolManager.m
//  SafeToolDemo
//
//  Created by Zack on 2019/8/29.
//  Copyright © 2019 ZackHyz. All rights reserved.
//

#import "ZHSafeToolManager.h"



@interface ZHSafeToolManager()<NSCopying,NSMutableCopying>

@property (nonatomic,copy) ZHSafeToolWarningObserverBlock warningObserverBlock ;
@end

static ZHSafeToolManager *manager = nil;

@implementation ZHSafeToolManager


+ (instancetype)shareManager{
    return [[self alloc] init];
}
    
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super init];
    });
    return manager;
}
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return manager;
}
    
- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return manager;
}
    
- (void)reportWarning:(NSString *)warning {
    if (self.warningObserverBlock != nil) {
        self.warningObserverBlock(warning);
    }
}

-(void)addWarningObserverUsingBlock:(ZHSafeToolWarningObserverBlock)block{
    self.warningObserverBlock = block;
}

@end

