//
//  ViewController.m
//  ZXZPhotoBrower
//
//  Created by YKJ2 on 16/9/14.
//  Copyright © 2016年 AAA. All rights reserved.
//

#import "ViewController.h"
#import "ZXZPhotoBrowerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)showAction:(id)sender {
    //支持本地和网络图片
    NSArray *arr = @[@"http://u68001-mk.thecloudimages.com/images/2016/08/MK_2.png",@"h1",@"http://u68001-mk.thecloudimages.com/images/2016/08/MK_2.png",@"http://u68001-mk.thecloudimages.com/images/2016/08/MK_1.png",@"h3"];
    ZXZPhotoBrowerController *vc = [[ZXZPhotoBrowerController alloc] initWithPhotos:arr];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
