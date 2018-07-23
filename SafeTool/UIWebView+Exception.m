//
//  UIWebView+Exception.m
//   
//
//  Created by Zack on 2018/3/19.
//  Copyright © 2018年 ZackHyz.. All rights reserved.
//

#import "UIWebView+Exception.h"
#import <objc/runtime.h>

@implementation UIWebView (Exception)

typedef void (*CallFuc)(id, SEL, BOOL);
typedef BOOL (*GetFuc)(id, SEL);

//打开/关闭 webview 的GL 
-(BOOL)enableGL:(BOOL)bEnable
{
    UIWebView *view = self;
    BOOL bRet = NO;
    do
    {
        Ivar internalVar = class_getInstanceVariable([view class], "_internal");
        if (!internalVar)
        {
            NSLog(@"enable GL _internal invalid!");
            break;
        }
        
        UIWebViewInternal* internalObj = object_getIvar(view, internalVar);
        Ivar browserVar = class_getInstanceVariable(object_getClass(internalObj), "browserView");
        if (!browserVar)
        {
            NSLog(@"enable GL browserView invalid!");
            break;
        }
        
        id webbrowser = object_getIvar(internalObj, browserVar);
        Ivar webViewVar = class_getInstanceVariable(object_getClass(webbrowser), "_webView");
        if (!webViewVar)
        {
            NSLog(@"enable GL _webView invalid!");
            break;
        }
        
        id webView = object_getIvar(webbrowser, webViewVar);
        if (!webView)
        {
            NSLog(@"enable GL webView obj nil!");
        }
        
        if(object_getClass(webView) != NSClassFromString(@"WebView"))
        {
            NSLog(@"enable GL webView not WebView!");
            break;
        }
        
        SEL selector = NSSelectorFromString(@"_setWebGLEnabled:");
        IMP impSet = [webView methodForSelector:selector];
        CallFuc func = (CallFuc)impSet;
        func(webView, selector, bEnable);
        
        SEL selectorGet = NSSelectorFromString(@"_webGLEnabled");
        IMP impGet = [webView methodForSelector:selectorGet];
        GetFuc funcGet = (GetFuc)impGet;
        BOOL val = funcGet(webView, selector);
        
        bRet = (val == bEnable);
        
    }while(NO);
    
    return bRet;
}


@end
