//
//  YFFindCardViewModel.m
//  YFKit
//
//  Created by 王宇 on 2018/6/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFFindCardViewModel.h"
#import "YFCarSourceModel.h"
#import "YFDriverDetailViewController.h"
@implementation YFFindCardViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page                   = 1;
    }
    return self;
}

#pragma mark 获取关注的数据
- (void)netWorkLike{
    NSMutableDictionary *param       = [NSMutableDictionary dictionary];
    if (!self.isSort) {
        [param safeSetObject:self.condition forKey:@"param"];
        //如果搜索条件为空 就手动改下isSort
        self.isSort                  = [NSString isBlankString:self.condition] ? NO : YES;
    }else{
        param                        = self.conditionDic;
    }
    @weakify(self)
    [WKRequest postWithURLString:@"app/consignerCar/getLikeCarList.do" parameters:param isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.dataArr           = [YFMayBeCarModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            if (self.dataArr.count == 0 && !self.isSort) {
                //页面初始化的时候如果没有关注的司机就显示可能关注的司机
                [self netWorkMayBeWithSuccess:^{
                    !self.refreshBlock ? : self.refreshBlock();
                }];
            }else if (self.dataArr.count == 0 && self.isSort){
                //如果搜索没有搜索到的时候, 需要展示空视图
                !self.failureBlock ? : self.failureBlock();
            }else{
                //有值的时候就正常展示
                !self.refreshBlock ? : self.refreshBlock();
            }
        }else{
            //请求失败展示空视图
            !self.failureBlock ? : self.failureBlock();
            [GiFHUD dismiss];
        }
    } failure:^(NSError *error) {
        @strongify(self)
        !self.failureBlock ? : self.failureBlock();
    }];
    
}

#pragma mark 获取可能关注的数据
- (void)netWorkMayBeWithSuccess:(void (^)(void))success{
    NSMutableDictionary *dict       = [NSMutableDictionary dictionary];
    [dict safeSetObject:@(self.page) forKey:@"page"];
    [dict safeSetObject:@(20) forKey:@"rows"];
    [dict safeSetObject:@"" forKey:@"condition"];
    @weakify(self)
    [WKRequest isHiddenActivityView:YES];
    [WKRequest postWithURLString:@"base/user/mayLikeCar.do" parameters:dict isJson:YES success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.likeDataArr        = [YFCarSourceModel mj_objectArrayWithKeyValuesArray:baseModel.data];
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
        success();
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 取消关注
- (void)cancelLikeWithCarId:(NSString *)carId DriverId:(NSString *)driverId{
    NSMutableDictionary *dict       = [NSMutableDictionary dictionary];
    [dict safeSetObject:carId forKey:@"carId"];
    [dict safeSetObject:driverId forKey:@"driverId"];
    @weakify(self)
    [WKRequest postWithURLString:@"app/consignerCar/unsubscribe.do" parameters:dict isJson:YES success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [YFToast showMessage:@"取消关注成功" inView:self.superVC.view];
            [self netWorkLike];
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark  添加关注车辆
- (void)likeCar:(NSString *)carId DriverId:(NSString *)driverId{
    NSMutableDictionary *dict       = [NSMutableDictionary dictionary];
    [dict safeSetObject:carId forKey:@"carId"];
    [dict safeSetObject:driverId forKey:@"driverId"];
    @weakify(self)
    [WKRequest postWithURLString:@"app/consignerCar/addLikeCar.do" parameters:dict isJson:YES success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [YFToast showMessage:@"关注成功" inView:self.superVC.view];
            [self netWorkLike];
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 跳转
- (void)jumpCtrlWithDriverId:(NSString *)driverId{
    YFDriverDetailViewController *detail = [YFDriverDetailViewController new];
    detail.driveId                       = driverId;
    detail.hidesBottomBarWhenPushed      = YES;
    @weakify(self)
    detail.refreashDriverDataBlock       = ^{
        @strongify(self)
        [self netWorkLike];
    };
    !self.jumpBlock ? : self.jumpBlock(detail);
}

@end
