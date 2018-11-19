//
//  YFUserCenterViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/4/28.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFUserCenterViewController.h"
#import "YFUserCenterHeadView.h"
#import "YFUserCenterTableViewCell.h"
#import "YFUserCenterService.h"
#import "YFUserCenterViewModel.h"
#import "YFPersonalMsgViewController.h"
#import "YFSettingViewController.h"

@interface YFUserCenterViewController ()
@property (nonatomic, strong, nullable) UICollectionView *collectionView;
@property (nonatomic, strong, nullable) YFUserCenterHeadView *headView;
@property (nonatomic, strong, nullable) NSArray *dataArr;
@property (nonatomic, strong, nullable) YFPersonImageModel *mainModel;
@property (nonatomic, strong, nullable) YFUserCenterService *service;
@property (nonatomic, strong, nullable) YFUserCenterViewModel *viewModel;
@end

@implementation YFUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                                   = @"我的";
    @weakify(self)
    [self.viewModel setUIWithSuccess:^{
        @strongify(self)
        [self.collectionView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (isLogin) {
        @weakify(self)
        [self.viewModel netWorkWithSuccess:^(YFPersonImageModel *pModel) {
            @strongify(self)
            self.headView.model          = pModel;
            [self.collectionView reloadData];
        }];
    }else{
        self.headView.model              = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [WKRequest isHiddenActivityView:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark collectionView
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout              = [[UICollectionViewFlowLayout alloc]init];
        _collectionView                                 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight) collectionViewLayout:layout];
        _collectionView.y                               = ISIPHONEX ? -20-XHEIGHT : -20;
        _collectionView.height                          = ISIPHONEX ? ScreenHeight-TabbarHeight + 20 + XHEIGHT : ScreenHeight-TabbarHeight + 20;
        _collectionView.delegate                        = self.service;
        _collectionView.dataSource                      = self.service;
//        _collectionView.bounces                         = NO;
        _collectionView.backgroundColor                 = UIColorFromRGB(0xF7F7F7);
        [_collectionView registerNib:[UINib nibWithNibName:@"YFUserCenterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFUserCenterCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"YFUserItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFUserItemCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"YFUserCenterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFUserCenterCollectionReusableView"];
        [self.view addSubview:_collectionView];
        
        CGFloat height                                  = 175.0f;
        _collectionView.contentInset                    = UIEdgeInsetsMake(height, 0.0f, 0.0f, 0.0f);
        _collectionView.alwaysBounceVertical            = YES;
        
        self.headView                                   = [[[NSBundle mainBundle] loadNibNamed:@"YFUserCenterHeadView" owner:nil options:nil] firstObject];
        self.headView.frame                             = CGRectMake(0, -height, ScreenWidth, height);
        self.headView.superVC                           = self;
        @weakify(self)
        [[self.headView.setBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            KUSERNOTLOGIN
            YFSettingViewController *set                = [YFSettingViewController new];
            set.hidesBottomBarWhenPushed                = YES;
            set.userName                                = self.viewModel.mainModel.realName;
            [self.navigationController pushViewController:set animated:YES];
        }];
        [_collectionView addSubview:self.headView];
        
    }
    return _collectionView;
}

#pragma mark service
- (YFUserCenterService *)service{
    if (!_service) {
        _service                                 = [[YFUserCenterService alloc]init];
        _service.viewModel                       = self.viewModel;
        _service.headView                        = self.headView;
    }
    return _service;
}

#pragma mark viewModel
- (YFUserCenterViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel                               = [[YFUserCenterViewModel alloc]init];
        _viewModel.superVC                       = self;
        @weakify(self)
        _viewModel.jumpBlock                     = ^(UIViewController *ctrl){
            @strongify(self)
            [self.navigationController pushViewController:ctrl animated:YES];
        };
    }
    return _viewModel;
}

#pragma mark 设置导航栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
