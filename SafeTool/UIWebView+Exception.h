//
//  UIWebView+Exception.h
//   
//
//  Created by Zack on 2018/3/19.
//  Copyright © 2018年 ZackHyz.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Exception)

//在后台的时候关掉WebGL防止随机崩溃
//从后台切回来再开启WebGL
-(BOOL)enableGL:(BOOL)bEnable;

@end
