//
//  YFUserCenterViewModel.m
//  YFKit
//
//  Created by 王宇 on 2018/6/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFUserCenterViewModel.h"
#import "YFSettingViewController.h"
#import "YFChooseDriverViewController.h"
#import "YFPersonalMsgViewController.h"
#import "YFQueryResultViewController.h"
#import "YFShareView.h"
#import "YFAllOrderViewController.h"
#import "YFAddressListViewController.h"
#import "YFMyMaturingCarViewController.h"

@implementation YFUserCenterViewModel

- (void)setUIWithSuccess:(void (^)(void))success{
    
    self.dataArr                                 = [NSArray getUserCenterArray];

    if (success) {
        success();
    }
}

#pragma mark 获取个人资料
- (void)netWorkWithSuccess:(void (^)(YFPersonImageModel *))success{
    [WKRequest isHiddenActivityView:YES];
    @weakify(self)
    [WKRequest getWithURLString:@"base/user/queryPerson.do" parameters:nil success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.mainModel                   = [YFPersonImageModel mj_objectWithKeyValues:baseModel.data];
            if (success) {
                success(self.mainModel);
            }
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 跳转
- (void)jumpCtrlWithSelectSection:(NSInteger)section SelectIndex:(NSInteger)index{
    if (index != 4) {
        KUSERNOTLOGIN
    }
    if (section == 0) {
        if (index == 0) {
            YFAllOrderViewController *list           = [YFAllOrderViewController new];
            list.hidesBottomBarWhenPushed            = YES;
            list.selectedIndex                       = 0;
            !self.jumpBlock ? : self.jumpBlock(list);
        }else if (index == 1){
            YFAllOrderViewController *list           = [YFAllOrderViewController new];
            list.hidesBottomBarWhenPushed            = YES;
            list.selectedIndex                       = 1;
            !self.jumpBlock ? : self.jumpBlock(list);
        }else if (index == 2){
            YFAllOrderViewController *list           = [YFAllOrderViewController new];
            list.hidesBottomBarWhenPushed            = YES;
            list.selectedIndex                       = 2;
            !self.jumpBlock ? : self.jumpBlock(list);
        }
    }else if (section == 1){
        if (index == 0) {
            //个人资料
            YFPersonalMsgViewController *person      = [YFPersonalMsgViewController new];
            person.hidesBottomBarWhenPushed          = YES;
            !self.jumpBlock ? : self.jumpBlock (person);
        }else if (index == 1){
            //发货人管理
            YFAddressListViewController *Address     = [YFAddressListViewController new];
            Address.hidesBottomBarWhenPushed         = YES;
            Address.isConsignor                      = YES;
            !self.jumpBlock ? : self.jumpBlock(Address);
        }else if (index == 2){
            //收货人管理
            YFAddressListViewController *Address     = [YFAddressListViewController new];
            Address.hidesBottomBarWhenPushed         = YES;
            !self.jumpBlock ? : self.jumpBlock(Address);
        }else if (index == 3){
            //我的熟车/常用司机
            YFChooseDriverViewController *maturing   = [YFChooseDriverViewController new];
            maturing.hidesBottomBarWhenPushed        = YES;
            !self.jumpBlock ? : self.jumpBlock (maturing);
        }else if (index == 4){
            //邀请好友
            [self shareView];
        }
    }
}
    
-(void)shareView{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    YFShareView *shareView = [[YFShareView alloc] initWithFrame:CGRectZero shareType:YFShareContentByAppType];
    shareView.shareContent = @"免费找车，实时竞价，飞一般的发货感受！";
    shareView.shareImage = @"shareIcon";
    shareView.shareTitle = @"做最省心的货主，就上乾坤货主APP！";
    shareView.superVC = self.superVC;
    shareView.shareUrl = @"http://app.yuanfusc.com/downapp/";
    [win addSubview:shareView];
}

@end
