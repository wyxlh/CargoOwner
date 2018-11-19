//
//  YFCarSourceViewModel.m
//  YFKit
//
//  Created by 王宇 on 2018/6/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFCarSourceViewModel.h"
#import "YFCarSourceModel.h"
#import "YFDriverDetailViewController.h"
@implementation YFCarSourceViewModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page                       = 1;
    }
    return self;
}
/**
 获取数据平台车辆信息
 */
- (void)netWork{
    NSMutableDictionary *dict           = [NSMutableDictionary dictionary];
    [dict safeSetObject:@(self.page) forKey:@"page"];
    [dict safeSetObject:@(20) forKey:@"rows"];
    if (!self.isSort) {
        NSMutableDictionary *parms      = [NSMutableDictionary dictionary];
        [parms safeSetObject:self.condition forKey:@"param"];
        [parms safeSetObject:@(self.onLine) forKey:@"onLine"];
        [dict safeSetObject:[NSString dictionTransformationJson:parms] forKey:@"condition"];
    }else{
        [dict safeSetObject:self.condition forKey:@"condition"];
    }
    @weakify(self)
    [WKRequest postWithURLString:@"v1/carSource/getSourceDriver.do" parameters:dict isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            if (self.page == 1) {
                self.dataArr            = [YFCarSourceModel mj_objectArrayWithKeyValuesArray:baseModel.data];
            }else{
                [self.dataArr addObjectsFromArray:[YFCarSourceModel mj_objectArrayWithKeyValuesArray:baseModel.data]];
            }
            !self.refreshBlock ? : self.refreshBlock();
        }else{
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
        }
        !self.failureBlock ? : self.failureBlock();
        
    } failure:^(NSError *error) {
        @strongify(self)
        !self.failureBlock ? : self.failureBlock();
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
            [YFToast showMessage:@"关注成功"];
            [YFNotificationCenter postNotificationName:@"AddLikeCarKeys" object:nil];
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
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
            self.page               = 1;
            [self netWork];
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 跳转
- (void)jumpCtrlWithDriverId:(NSString *)driverId{
    KUSERNOTLOGIN
    YFDriverDetailViewController *detail = [YFDriverDetailViewController new];
    detail.hidesBottomBarWhenPushed      = YES;
    detail.driveId                       = driverId;
//    @weakify(self)
//    detail.refreashDriverDataBlock       = ^{
//        @strongify(self)
//        self.page                        = 1;
//        [self netWork];
//    };
    !self.jumpBlock ? : self.jumpBlock(detail);
}

- (NSMutableArray<YFCarSourceModel *> *)dataArr{
    if (!_dataArr) {
        _dataArr                     = [NSMutableArray new];
    }
    return _dataArr;
}

@end
