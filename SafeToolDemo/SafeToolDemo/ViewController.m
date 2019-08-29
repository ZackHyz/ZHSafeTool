//
//  ViewController.m
//  SafeToolDemo
//
//  Created by Zack on 2018/7/23.
//  Copyright © 2018年 ZackHyz. All rights reserved.
//

#import "ViewController.h"
#import "ZHSafeToolManager.h"

#define kNotification [NSNotificationCenter defaultCenter]


@interface ViewController ()
@property (strong, nonatomic) UIWebView * webView; //webview

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addEnterBackgroundNoc];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *a = [NSMutableArray new];
//    [a addObject:@"0"];
    a[1] = @"1";
    
    [a performSelector:@selector(aaaaaaa)];
    NSLog(@"%@",a);
    
    CGFloat width = 0;
    CGRect frame = CGRectMake(0, 0, 11/width, INFINITY);
    UIView *view;
    view.frame = frame;
    
    
    NSMutableArray *b = [NSMutableArray new];
    [b addObject:@"1"];
    [b addObject:@"2"];
    [b subarrayWithRange:NSMakeRange(-1, 3)];
    
    [[ZHSafeToolManager shareManager]addWarningObserverUsingBlock:^(NSString * _Nonnull warning) {
        NSLog(@"%@", warning);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addEnterBackgroundNoc
{
    [kNotification addObserver:self
                      selector:@selector(disableGL)
                          name:UIApplicationDidEnterBackgroundNotification
                        object:nil];
    [kNotification addObserver:self
                      selector:@selector(enableGL)
                          name:UIApplicationDidBecomeActiveNotification
                        object:nil];
}

//-(void)enableGL{
//    [self enableGL:YES];
//}
//
//-(void)disableGL{
//    [self enableGL:NO];
//}
//-(void)enableGL:(BOOL)bEnable{
//    //在后台的时候关掉WebGL防止随机崩溃
//    if([self.webView enableGL:bEnable]){
//        NSLog(@"enable GL :%d",bEnable);
//    }else{
//        NSLog(@"Can't enable GL :%d",bEnable);
//    }
//}
//
//-(UIWebView *)webView
//{
//    if (!_webView) {
//        _webView = [[UIWebView alloc] init];
//    }
//    return _webView;
//}

@end
