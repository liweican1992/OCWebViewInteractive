//
//  WKWebViewDemoViewController.m
//  OCWebViewInterac
//
//  Created by CC on 17/7/31.
//  Copyright © 2017年 cc412. All rights reserved.
//

#import "WKWebViewDemoViewController.h"
#import <WebKit/WebKit.h>
#import "GoodDetailViewController.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface WKWebViewDemoViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) WKWebView * webView;
@end

@implementation WKWebViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];

    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
//    self.webView.scrollView.delegate = self;

    [self.view addSubview:_webView];
    
    self.webView.backgroundColor = [UIColor whiteColor];
    
    //加载网络Html
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jianshu.com/u/ba0b803ae8b9"]]];
    
    /**
     * 下面方法是加载本地html文件的方法 加载网络的请忽略
     */
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    if(path){
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            // iOS9. One year later things are OK.
            NSURL *fileURL = [NSURL fileURLWithPath:path];
            [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
        } else {
    
            NSURL *fileURL = [self fileURLForBuggyWKWebView8:[NSURL fileURLWithPath:path]];
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [self.webView loadRequest:request];
        }
    }
    


}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.webView.scrollView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.webView.scrollView.delegate = nil;
}

//将文件copy到tmp目录
- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}

@end
