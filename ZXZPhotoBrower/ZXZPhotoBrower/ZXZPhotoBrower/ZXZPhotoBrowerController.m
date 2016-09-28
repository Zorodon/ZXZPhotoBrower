//
//  ZXZPhotoBrowerController.m
//  BeiLu
//
//  Created by YKJ2 on 16/4/21.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "ZXZPhotoBrowerController.h"
#import "UIImageView+WebCache.h"
#import "ZXZPhotoScrollView.h"
#import "MBProgressHUD+NJ.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ZXZPhotoBrowerController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *titleL;

@property (strong, nonatomic) NSArray *photos;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSMutableArray *imageViewArr;

@end

@implementation ZXZPhotoBrowerController

- (NSMutableArray *)imageViewArr {
    if (!_imageViewArr) {
        _imageViewArr = [NSMutableArray array];
    }
    return _imageViewArr;
}
- (instancetype)initWithPhotos:(NSArray *)photos {
    return [self initWithPhotos:photos index:0];
}
- (instancetype)initWithPhotos:(NSArray *)photos index:(NSInteger)idx{
    self = [super init];
    if (self) {
        self.photos = photos;
        self.currentIndex = idx;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPhotoScrollView];
}

- (void)initPhotoScrollView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    headView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:headView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.textColor = [UIColor whiteColor];
    cancelBtn.frame = CGRectMake(10, 20, 80, 44);
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:cancelBtn];
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, 20, 200, 44)];
    self.titleL.font = [UIFont boldSystemFontOfSize:18];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.textColor = [UIColor whiteColor];
    self.titleL.text = [NSString stringWithFormat:@"%ld / %lu",self.currentIndex+1,self.photos.count];
    [headView addSubview:self.titleL];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    saveBtn.titleLabel.textColor = [UIColor whiteColor];
    saveBtn.frame = CGRectMake(kScreenWidth-10-80, 20, 80, 44);
    saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:saveBtn];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    for (int i=0; i<self.photos.count; i++) {
        ZXZPhotoScrollView *photoScrollView = [[ZXZPhotoScrollView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight-64)];
        [self.scrollView addSubview:photoScrollView];
        [self.imageViewArr addObject:photoScrollView];
    }
    [self startDownloadImageWithIndex:self.currentIndex];
    self.scrollView.contentSize = CGSizeMake(self.photos.count*kScreenWidth, kScreenHeight-64);
    [self.scrollView setContentOffset:CGPointMake(self.currentIndex*kScreenWidth, 0) animated:YES];
    [self.view addSubview:self.scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveAction:(id)sender {
    ZXZPhotoScrollView *photoScrollView = self.imageViewArr[self.currentIndex];
    UIImageView *imageView = photoScrollView.imageView;
    if (imageView.image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
        
    }else{
        [MBProgressHUD showError:@"图片正在加载中"];
    }
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error != NULL){
        [MBProgressHUD showError:@"保存图片失败"];
    }else{
        [MBProgressHUD showSuccess:@"保存图片成功"];
    }
}

- (void)startDownloadImageWithIndex:(NSInteger)idx {
    ZXZPhotoScrollView *photoScrollView = self.imageViewArr[idx];
    UIImageView *imageView = photoScrollView.imageView;
    if ([[self.photos[idx] lowercaseString] hasPrefix:@"http"]) {
        __block UIActivityIndicatorView *activityIndicator;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.photos[idx]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (!activityIndicator){
                activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [imageView addSubview:activityIndicator];
                activityIndicator.center = CGPointMake(imageView.frame.size.width/2, imageView.frame.size.height/2);
                [activityIndicator startAnimating];
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
            if (error) {
                imageView.image = [UIImage imageNamed:@"photofail"];
            }
        }];
    }else{
        imageView.image = [UIImage imageNamed:self.photos[idx]];
    }
}


#pragma mark - UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger nextIndex = scrollView.contentOffset.x/kScreenWidth;
    if (nextIndex!=self.currentIndex) {
        [self startDownloadImageWithIndex:nextIndex];
        self.titleL.text =[NSString stringWithFormat:@"%ld / %lu",nextIndex+1,self.photos.count];
    }
    self.currentIndex = nextIndex;
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    ZXZPhotoScrollView *photoScrollView = self.imageViewArr[self.currentIndex];
    [photoScrollView setZoomScale:1 animated:YES];
}
@end
