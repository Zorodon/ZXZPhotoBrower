//
//  ZXZScrollView.m
//  BeiLu
//
//  Created by YKJ2 on 16/4/21.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "ZXZPhotoScrollView.h"

@interface ZXZPhotoScrollView()<UIScrollViewDelegate>
@property (assign,nonatomic) BOOL tapClick;

@end

@implementation ZXZPhotoScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        self.maximumZoomScale = 10;
        self.minimumZoomScale = 1;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        self.tapClick = NO;
    }
    return self;
}

- (void)doubleTap {
    self.tapClick = !self.tapClick;
    if (self.tapClick) {
        [self setZoomScale:3 animated:YES];//双击3倍放大
    }else{
        [self setZoomScale:1 animated:YES];
    }
}

#pragma mark - UIScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
}
@end
