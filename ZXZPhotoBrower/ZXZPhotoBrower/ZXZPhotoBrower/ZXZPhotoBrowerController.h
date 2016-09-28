//
//  ZXZPhotoBrowerController.h
//  BeiLu
//
//  Created by YKJ2 on 16/4/21.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXZPhotoBrowerController : UIViewController
- (instancetype)initWithPhotos:(NSArray *)photos;
- (instancetype)initWithPhotos:(NSArray *)photos index:(NSInteger)idx;//定位第几张图片

@end
