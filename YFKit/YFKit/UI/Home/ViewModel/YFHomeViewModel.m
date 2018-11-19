//
//  YFHomeViewModel.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFHomeViewModel.h"
#import "YFReleaseViewController.h"
#import "YFPlaceOrderViewController.h"
#import "YFHomeNearMapViewController.h"
#import "YFSpeciallinePlanOrderViewController.h"
#import "YFLocationModel.h"
#import "YFUmengTracking.h"
#import "YFPersonalMsgViewController.h"

@implementation YFHomeViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleArr                  = [NSArray getHomeTitleArray];
        self.imgArr                    = [NSArray getHomeImageArray];
        self.trackingArr               = [NSArray getHomeIdentificationArray];
        isLogin ? [self cancleUnread] : nil;
        [self LocationWithSuccessBlock:nil];
    }
    return self;
}

- (void)jumpCtrlWithSelectSection:(NSInteger)section SelectIndex:(NSInteger)index{
    if (section == 0) {
        KUSERNOTLOGIN
        // 如果账户编码为008 需要完善资料 再去发布货源 如果不是直接就可以发布货源
        DLog(@"%d -------%d",[[UserData userInfo].userInfoStatus boolValue],IS_CARGO_OWNER);
        if (![[UserData userInfo].userInfoStatus boolValue] && index != 2 && IS_CARGO_OWNER) {
            @weakify(self)
            [self.superVC showAlertViewControllerTitle:wenxinTitle Message:@"请完善个人资料,否则无法下单!" CancelTitle:@"暂不完善" CancelTextColor:ConfirmColor ConfirmTitle:@"去完善" ConfirmTextColor:CancelColor cancelBlock:^{
                
            } confirmBlock:^{
                @strongify(self)
                YFPersonalMsgViewController *person = [YFPersonalMsgViewController new];
                person.hidesBottomBarWhenPushed = YES;
                [self.superVC.navigationController pushViewController:person animated:YES];
            }];
            return;
        }
        if (index == 0) {
            //发布货源
            YFReleaseViewController *release           = [YFReleaseViewController new];
            release.hidesBottomBarWhenPushed           = YES;
            !self.jumpBlock ? : self.jumpBlock (release);
        }else if (index == 1){
            // 发布订单
            YFPlaceOrderViewController *place          = [YFPlaceOrderViewController new];
            place.hidesBottomBarWhenPushed             = YES;
            place.isNewOrder                           = YES;
            !self.jumpBlock ? : self.jumpBlock (place);
        }else if (index == 2){
            if (!IS_CARGO_OWNER) {
                //如果货源编码
                YFSpeciallinePlanOrderViewController *line = [YFSpeciallinePlanOrderViewController new];
                line.hidesBottomBarWhenPushed          = YES;
                !self.jumpBlock ? : self.jumpBlock (line);
            }else{
                [YFToast showMessage:@"暂无权限" inView:self.superVC.view];
            }
        }
    }else if (section == 1){
        if ([YFLocationModel openLocationService]) {
            //打开定位
            if (self.latitude == 0) {
                @weakify(self)
                [self LocationWithSuccessBlock:^{
                    @strongify(self)
                    [self jumpNearMapWithSelectSection:section SelectIndex:index];
                }];
            }else{
                [self jumpNearMapWithSelectSection:section SelectIndex:index];
            }
        }else{
            //没有开打开定位
            [YFToast showMessage:@"请打开定位服务"];
            return;
        }
    }
}

/**
 附近的一些东西
 */
- (void)jumpNearMapWithSelectSection:(NSInteger)section SelectIndex:(NSInteger)index{
    YFHomeNearMapViewController *near          = [YFHomeNearMapViewController new];
    near.hidesBottomBarWhenPushed              = YES;
    near.title                                 = self.titleArr[index];
    near.city                                  = self.city;
    near.latitude                              = self.latitude;
    near.longitude                             = self.longitude;
    near.index                                 = index;
    if (index == 0) {
        near.keywords                          = @"仓库";
    }else if (index == 1){
        near.keywords                          = @"工业园区";
    }else if (index == 2){
        near.keywords                          = @"物流园区";
    }else if (index == 3){
        near.keywords                          = @"餐饮";
    }else if (index == 4){
        near.keywords                          = @"住宿";
    }else if (index == 5){
        near.keywords                          = @"停车场";
    }
    [YFUmengTracking umengEvent:self.trackingArr[index]];
    !self.jumpBlock ? : self.jumpBlock (near);
}

/**
 定位
 */
- (void)LocationWithSuccessBlock:(void (^)(void))success{
    //得到定位信息
    [[YFLocationModel sharedYFLocationModel] reGeocodeAction];
    @weakify(self)
    [YFLocationModel sharedYFLocationModel].backUserAddressDetailBlock = ^(AMapLocationReGeocode *regeocode, CGFloat latitude, CGFloat longitude){
        @strongify(self)
        self.city                             = regeocode.city;
        self.latitude                         = latitude;
        self.longitude                        = longitude;
        if (success) {
            success();
        }
    };
}

/**
 获取取消订单次数 显示小圆点
 */
- (void)cancleUnread{
    [WKRequest isHiddenActivityView:YES];
    [WKRequest getWithURLString:@"v1//cancle/unread/count.do" parameters:nil success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            NSInteger count = [[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"count"] integerValue];
            [YFOfferData shareInstace].cancelOrderSuccessCount = count;
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
