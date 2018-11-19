//
//  YFHomeViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/4/28.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFHomeViewController.h"
#import <SDCycleScrollView.h>
#import "YFHomeService.h"
#import "YFHomeViewModel.h"

@interface YFHomeViewController ()
@property (nonatomic, strong, nullable) UICollectionView *collectionView;
@property (nonatomic, strong, nullable) SDCycleScrollView *_bannerView;
@property (nonatomic, strong, nullable) NSMutableArray *_imageUrls;
@property (nonatomic, strong, nullable) YFHomeService *service;
@property (nonatomic, strong, nullable) YFHomeViewModel *viewModel;
@end

@implementation YFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}

- (void)setUI{
    self.automaticallyAdjustsScrollViewInsets           = NO;
    //验证用户资料是否是完整的
    isLogin ? [YFLoginModel verifyInformationIntegrity] : nil;
    [self.collectionView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark collectionView
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout           = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing                    = 1.5;
        layout.minimumInteritemSpacing               = 1.5;
        _collectionView                              = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabbarHeight) collectionViewLayout:layout];
        _collectionView.y                            = ISIPHONEX ? -20-XHEIGHT : -20;
        _collectionView.height                       = ISIPHONEX ? ScreenHeight-TabbarHeight + 20 + XHEIGHT : ScreenHeight-TabbarHeight + 20;
        _collectionView.delegate                     = self.service;
        _collectionView.dataSource                   = self.service;
//        _collectionView.bounces                      = NO;
        _collectionView.backgroundColor              = UIColorFromRGB(0xF4F5F6);
        [_collectionView registerNib:[UINib nibWithNibName:@"YFHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFHomeCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"YFHomePostCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFHomePostCollectionViewCell"];
        [self.view addSubview:_collectionView];
        
        CGFloat scale                                = 750.0f/423.0f;
        CGFloat height                               = ScreenWidth/scale;
        _collectionView.contentInset                 = UIEdgeInsetsMake(height, 0.0f, 10.0f, 0.0f);
        _collectionView.alwaysBounceVertical         = YES;
        
        NSArray *_imageUrls = @[@"banner",@"banner1",@"banner2"];
        
        SDCycleScrollView *cycleScrollView          = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -height, ScreenWidth,height) delegate:nil placeholderImage:[UIImage imageNamed:@"banner"]];
        cycleScrollView.pageControlAliment          = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.clickItemOperationBlock     = ^(NSInteger currentIndex) {
            
        };
        cycleScrollView.currentPageDotColor         = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        self._bannerView                            = cycleScrollView;
        cycleScrollView.localizationImageNamesGroup = _imageUrls;
        cycleScrollView.hidden                      = _imageUrls.count == 0 ? YES : NO ;
        [_collectionView addSubview:cycleScrollView];

    }
    return _collectionView;
}

#pragma mark service
-(YFHomeService *)service{
    if (!_service) {
        _service                                    = [[YFHomeService alloc]init];
        _service.viewModel                          = self.viewModel;
    }
    return _service;
}

#pragma mark viewModel
-(YFHomeViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel                                  = [[YFHomeViewModel alloc]init];
        _viewModel.superVC                          = self;
        @weakify(self)
        _viewModel.jumpBlock                        = ^(UIViewController *ctrl){
            @strongify(self)
            [self.navigationController pushViewController:ctrl animated:YES];
        };
    }
    return _viewModel;
}

#pragma mark 设置导航栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
