//
//  UIWebViewDemoViewController.m
//  OCWebViewInterac
//
//  Created by CC on 17/7/31.
//  Copyright © 2017年 cc412. All rights reserved.
//

#import "UIWebViewDemoViewController.h"
#import "GoodDetailViewController.h"

@interface UIWebViewDemoViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation UIWebViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    NSString *pathStr = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pathStr]]];
    

}
#pragma mark -
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = request.URL.absoluteString;
    //app-cc412 开头 一般跳转原生界面  app-cc412:goodsId=3254
    if ([urlStr hasPrefix:@"app-cc412"]) {
        NSLog(@"拦截请求%@",urlStr);
        NSArray *arr = [urlStr componentsSeparatedByString:@":"];
        NSString *lastStr = arr.lastObject;//goodId=3254
        NSArray *valueArr = [lastStr componentsSeparatedByString:@"="];
        if (!valueArr.count) {
            return  YES;
        }
        NSString *value1 = valueArr.firstObject;
        NSString *value2 = valueArr.lastObject;
        //去单品详情
        if ([value1 isEqualToString:@"goodsId"]) {
            GoodDetailViewController *detailVc = [[GoodDetailViewController alloc]init];
            detailVc.goodId = value2;
            [self.navigationController pushViewController:detailVc animated:YES];
        }
//        if ([value1 isEqualToString:@"xxx"]) {
//
//        }
        return NO;

    }
    if ([urlStr hasPrefix:@"app-userid-cc412:"]) {
        /**
         * 判断App里面用户是否登录什么的。。。过程略
         */
        NSString *userId = @"cc412";
        //调用JS函数
        NSString *fun = [NSString stringWithFormat:@"app_cc412_JSAction_userId('%@')",userId];
        [self.webView stringByEvaluatingJavaScriptFromString:fun];
        
        return NO;
    }
    
    /**
     *  点击多个按钮 获取按钮的tag值，然后调用JS函数
     *
     *  @param hasPrefix:@"app-userid-cc412-tag:"] 定义的拦截事件
     JS函数名固定app_cc412_JSAction_userId_tag(userid,tag)
     */
    if([urlStr hasPrefix:@"app-userid-cc412-tag:"]){
        /**
         * 判断App里面用户是否登录什么的。。。过程略
         */
        NSArray *arr = [urlStr componentsSeparatedByString:@":"];
        NSString *str = arr.lastObject;
        if (str.length) {
            NSArray *valueArr = [str componentsSeparatedByString:@"="];
            if (valueArr.count == 2) {
                NSString *tag = valueArr.lastObject;
                NSString * func = [NSString stringWithFormat:@"app_cc412_JSAction_userId_tag('%@','%@');",@"cc412",tag];
                [self.webView stringByEvaluatingJavaScriptFromString:func];
                
            }
        }

        return NO;
    }
    
    return YES;
}

@end
