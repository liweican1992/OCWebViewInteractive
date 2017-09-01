//
//  GoodDetailViewController.m
//  OCWebViewInterac
//
//  Created by CC on 17/8/1.
//  Copyright © 2017年 cc412. All rights reserved.
//

#import "GoodDetailViewController.h"

@interface GoodDetailViewController ()
@property (nonatomic,strong) UILabel * label;
@end

@implementation GoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"单品详情"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 20)];
    [self.view addSubview:_label];
    _label.text = [NSString stringWithFormat:@"商品ID%@",_goodId];
}


@end
