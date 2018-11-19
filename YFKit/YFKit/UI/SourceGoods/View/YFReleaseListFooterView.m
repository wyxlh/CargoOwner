//
//  YFHistoryListFooterView.m
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//
#define BtnGrayColor   UIColorFromRGB(0x98999A)

#import "YFReleaseListFooterView.h"
#import "YFLookSignInViewController.h"
#import "YFBiddingListViewController.h"
#import "YFPlaceOrderViewController.h"
#import "YFReleaseViewController.h"
#import "YFCancelSourceViewController.h"
#import "YFReleseListModel.h"
#import "YFOrderListModel.h"
#import "YFReleseDetailModel.h"
#import "YFAdjFreeAlertView.h"
#import "YFOrderDetailModel.h"
#import "YFShareView.h"

@implementation YFReleaseListFooterView

-(void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self.leftBtn, 1, 0, NavColor);
    SKViewsBorder(self.rightBtn, 1, 0, NavColor);
    SKViewsBorder(self.countLbl, 6.5, 0, NavColor);
}

/**
货源列表的数据赋值
 */
-(void)setRmodel:(YFReleseListModel *)Rmodel{
    _Rmodel                                  = Rmodel;
    self.countLbl.text                       = _Rmodel.priceCount;
    if (self.type == 1) {
        //发布中
        self.leftBtn.hidden                  = self.rightBtn.hidden = self.freeBtn.hidden = self.wechatBtn.hidden = NO;
        [self.wechatBtn setTitle:@"取消" forState:0];
        [self.freeBtn setTitle:@"刷新置顶" forState:0];
        [self.leftBtn setTitle:@"发到微信" forState:0];
        [self.rightBtn setTitle:@"查看报价" forState:0];
        //因为 rightBtn freeBtn 的颜色没有其他变化因此不用设置
        self.wechatBtn.backgroundColor       = OrangeBtnColor;
        self.rightBtn.userInteractionEnabled = [Rmodel.priceCount integerValue] == 0 ? NO : YES;
        self.rightBtn.backgroundColor        = [Rmodel.priceCount integerValue] == 0 ? BtnGrayColor : BlueBtnColor;
        self.leftBtn.backgroundColor         = BlueBtnColor;
        self.countLbl.hidden                 = [_Rmodel.priceCount integerValue] == 0 ? YES : NO;
        //刷新置顶 第一条数据不需要做此操作
        self.freeBtn.userInteractionEnabled  = self.section == 0 ? NO : YES;
        self.freeBtn.backgroundColor         = self.section == 0 ? BtnGrayColor : BlueBtnColor;
        
    }else if (self.type == 3){
        //未承运
        self.leftBtn.hidden = self.wechatBtn.hidden = self.rightBtn.hidden = self.freeBtn.hidden = NO;
        [self.wechatBtn setTitle:Rmodel.taskFlag.integerValue == 4 ? @"待确认" : @"取消" forState:0];
        [self.freeBtn setTitle:@"联系司机" forState:0];
        [self.leftBtn setTitle:@"发到微信" forState:0];
        [self.rightBtn setTitle:@"再发一单" forState:0];
        self.wechatBtn.backgroundColor       = Rmodel.taskFlag.integerValue == 4 ? BtnGrayColor : OrangeBtnColor;
        self.leftBtn.backgroundColor         = BlueBtnColor;
    }else if (self.type == 2){
        //已承运
        self.leftBtn.hidden                  = self.rightBtn.hidden = NO;
        [self.leftBtn setTitle:@"联系司机" forState:0];
        [self.rightBtn setTitle:@"再发一单" forState:0];
        //因为 rightBtn freeBtn 的颜色没有其他变化因此不用设置
        self.leftBtn.backgroundColor         = BlueBtnColor;
    }else{
        //已取消
        self.rightBtn.hidden                 = NO;
        [self.rightBtn setTitle:@"再发一单" forState:0];
    }
}

/**
 订单列表的数据赋值
 */
-(void)setOmodel:(YFOrderListModel *)Omodel{
    _Omodel                               = Omodel;
    self.wechatBtn.hidden                 = YES;
    if (self.type == 1) {
        if (Omodel.taskStatus == 0) {
             self.rightBtn.hidden         = NO;
            //设置 title
            [self.rightBtn setTitle:@"联系司机" forState:0];
            //设置颜色
            [self.rightBtn setBackgroundColor:BlueBtnColor];
        }else if (Omodel.taskStatus == 1 || Omodel.taskStatus == 2 || Omodel.taskStatus == 3){
            self.rightBtn.hidden          = self.leftBtn.hidden = NO;
            //设置 title
            [self.leftBtn setTitle:Omodel.addAmountComfirmStatus.integerValue == 2 ? @"待确认" : @"调整运费" forState:0];
            [self.rightBtn setTitle:@"联系司机" forState:0];
            //设置颜色
            self.leftBtn.backgroundColor = Omodel.addAmountComfirmStatus.integerValue == 2 ? BtnGrayColor : BlueBtnColor;
            [self.rightBtn setBackgroundColor:BlueBtnColor];
        }else if (Omodel.taskStatus == 4){
            self.leftBtn.hidden = self.rightBtn.hidden = self.freeBtn.hidden = NO;
            self.leftBtn.enabled = Omodel.addAmountComfirmStatus.integerValue == 2 ? NO : YES;
            //设置 title
             [self.freeBtn setTitle:Omodel.addAmountComfirmStatus.integerValue == 2 ? @"待确认" : @"调整运费" forState:0];
            [self.leftBtn setTitle:@"确认收货" forState:0];
            [self.rightBtn setTitle:@"联系司机" forState:0];
            //设置颜色
            self.freeBtn.backgroundColor = Omodel.addAmountComfirmStatus.integerValue == 2 ? BtnGrayColor : BlueBtnColor;
            self.leftBtn.backgroundColor = Omodel.addAmountComfirmStatus.integerValue == 2 ? BtnGrayColor : BlueBtnColor;
            [self.rightBtn setBackgroundColor:BlueBtnColor];
        }
    }else{
        if (Omodel.confirmStatus == 0 && Omodel.taskFlag != 1) {
            //这个条件是已取消状态
            self.rightBtn.hidden          = NO;
            [self.rightBtn setTitle:@"重新下单" forState:0];
        }else{
            self.rightBtn.hidden          = NO;
            [self.rightBtn setTitle:@"查看签收单" forState:0];
        }
    }
}

#pragma mark 按钮点击 这里是根据title来判断执行什么操作
- (IBAction)clickBtn:(UIButton *)sender {
    WS(weakSelf)
    if ([sender.titleLabel.text isEqualToString:@"查看签收单"]) {
        //查看签收单
        YFLookSignInViewController *look             = [[YFLookSignInViewController alloc]initWithNibName:@"YFLookSignInViewController" bundle:nil];
        look.taskId                                  = self.Omodel.taskId;
        look.hidesBottomBarWhenPushed                = YES;
        [self.superVC.navigationController pushViewController:look animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"查看报价"]){
        //查看报价
        YFBiddingListViewController *list            = [YFBiddingListViewController new];
        list.hidesBottomBarWhenPushed                = YES;
        list.releaseTime                             = _Rmodel.publishedTime;
        list.Id                                      = _Rmodel.Id;
        [self.superVC.navigationController pushViewController:list animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"取消"]){
        //取消货源
        if (self.type == 1) {
            //发布中 可随意取消
            [self jumpCancelCtrlWithTimes:0];
        }else{
            [self canCancelSourceOrderWithSuccess:^{
                //未承运中司机未接单取消受到3次限制
                if (!weakSelf.Rmodel.taskStatus) {
                    [weakSelf queryRemainingTimesWithCancelSuccess:^(NSInteger count) {
                        [weakSelf jumpCancelCtrlWithTimes:count];
                    } CancelFail:^{
                        [YFToast showMessage:@"超过三次，禁止取消！" inView:weakSelf.superVC.view];
                    }];
                }else{
                    //已接单 只要司机同意 可随意取消
                    [weakSelf jumpCancelCtrlWithTimes:0];
                }
            }];
        }
    }else if ([sender.titleLabel.text isEqualToString:@"联系司机"]){
        //联系司机
        if (self.Rmodel) {
            NSString *driverMobile = [NSString stringWithFormat:@"tel:%@",self.Rmodel.phone];
            if (![NSString isBlankString:self.Rmodel.phone]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:driverMobile]];
            }else{
                [YFToast showMessage:@"该司机电话号码为空" inView:self.superVC.view];
            }
        }else{
            NSString *driverMobile = [NSString stringWithFormat:@"tel:%@",self.Omodel.driverMobile];
            if (![NSString isBlankString:self.Omodel.driverMobile]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:driverMobile]];
            }else{
                [YFToast showMessage:@"该司机电话号码为空" inView:self.superVC.view];
            }
        }
    }else if ([sender.titleLabel.text isEqualToString:@"取消订单"]){
        //取消订单
    }else if ([sender.titleLabel.text isEqualToString:@"确认收货"]){
        //确认收货 因为如果说在这里发一个通知的话 会导致 在在 VC 中发通知的时候, 第二次执行 会执行两次
        [self.superVC showAlertViewControllerTitle:wenxinTitle Message:@"您是否要确认收货?" CancelTitle:@"取消" CancelTextColor:CancelColor ConfirmTitle:@"确定" ConfirmTextColor:ConfirmColor cancelBlock:^{
            
        } confirmBlock:^{
            //因需要定位 所以要把这个放到了 VC 中
            !self.confirmCollectGoodsBlock ? : self.confirmCollectGoodsBlock(weakSelf.Omodel);
        }];
        
    }else if ([sender.titleLabel.text isEqualToString:@"再发一单"]){
        //在发一单
        [self goodDetail];
        
    }else if ([sender.titleLabel.text isEqualToString:@"调整运费"]){
        //调整运费
        [self canAdjustmentFeeWithCanSuccess:^{
            YFAdjFreeAlertView *alert = [[[NSBundle mainBundle]loadNibNamed:@"YFAdjFreeAlertView" owner:nil options:nil] lastObject];
            alert.model               = weakSelf.Omodel;
            [alert show:YES];
            alert.adjustmentFreeBlock = ^(BOOL isSuccess, NSString *msg, NSString *taskFree){
                if (isSuccess) {
                    !weakSelf.refreshDataBlock ? : weakSelf.refreshDataBlock();
                    [YFToast showMessage:msg inView:weakSelf.superVC.view];
                }else{
                    [YFToast showMessage:msg inView:weakSelf.superVC.view];
                }
            };
            [YFWindow addSubview:alert];
        }];
        
    }else if ([sender.titleLabel.text isEqualToString:@"重新下单"]){
        //重新下单
        [self Confirmation];
    }else if ([sender.titleLabel.text isEqualToString:@"发到微信"]){
        //分享微信
        [self shareView];
    }else if ([sender.titleLabel.text isEqualToString:@"刷新置顶"]){
        //刷新置顶
        [self refreshTop];
    }
}

- (void)jumpCancelCtrlWithTimes:(NSInteger)times{
    YFCancelSourceViewController *cancel          = [YFCancelSourceViewController new];
    cancel.hidesBottomBarWhenPushed               = YES;
    cancel.cancelType                             = self.type == 1 ? YFCancelSourceStateReleaseType : YFCancelSourceStateNonCarrierType;
    cancel.type                                   = 2;
    cancel.rModel                                 = self.Rmodel;
    cancel.times                                  = times;
    WS(weakSelf)
    cancel.cancelSuccessBlock                     = ^{
//        [YFToast showMessage:@"取消成功" inView:weakSelf.superVC.view];
        !weakSelf.refreshDataBlock ? : weakSelf.refreshDataBlock();
    };
    [weakSelf.superVC.navigationController pushViewController:cancel animated:YES];
}

#pragma mark 获取司机未接单 取消货源的次数
- (void)queryRemainingTimesWithCancelSuccess:(void(^)(NSInteger))cancelSuccess CancelFail:(void(^)(void))cancelFail{
    [WKRequest isHiddenActivityView:YES];
    WS(weakSelf)
    [WKRequest getWithURLString:@"v1/cancle/count.do" parameters:nil success:^(WKBaseModel *baseModel) {
        if (CODE_ZERO) {
            NSInteger count = [[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"count"] integerValue];
            count > 0 ? cancelSuccess(count) : cancelFail();
        }else{
            [YFToast showMessage:baseModel.message inView:weakSelf.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 获取货源订单详情 并在发一单
-(void)goodDetail {
    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
    [parms safeSetObject:@(2) forKey:@"type"];
    [parms safeSetObject:_Rmodel.Id forKey:@"id"];
    @weakify(self)
    [WKRequest getWithURLString:@"v1/goods/2/get.do" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            YFReleaseViewController *release = [YFReleaseViewController new];
            release.hidesBottomBarWhenPushed = YES;
            release.detailModel              = [YFReleseDetailModel mj_objectWithKeyValues:baseModel.data];
            [self.superVC.navigationController pushViewController:release animated:YES];
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 验证是否能取消货源
- (void)canCancelSourceOrderWithSuccess:(void(^)(void))success {
    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.Rmodel.taskId forKey:@"taskId"];
    @weakify(self)
    [WKRequest getWithURLString:@"v1//is/not/cancle/price/changes.do" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            success();
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 验证订单是否能调整运费
- (void)canAdjustmentFeeWithCanSuccess:(void(^)(void))canSuccess {
    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
    [parms safeSetObject:_Omodel.taskId forKey:@"taskId"];
    @weakify(self)
    [WKRequest getWithURLString:@"v1/is/not/cancle.do" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            canSuccess();
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

//#pragma mark  调整运费
//-(void)adjustmentFree {
//    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
//    [parms safeSetObject:_Omodel.taskId forKey:@"taskId"];
//    [parms safeSetObject:_Omodel.Id forKey:@"id"];
//    [parms safeSetObject:@"300" forKey:@"addAmount"];
//    [parms safeSetObject:@"1" forKey:@"remark"];
//    @weakify(self)
//    [WKRequest postWithURLString:@"v1/taskOrder/addCount.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
//         @strongify(self)
//        if (CODE_ZERO) {
//
//        }else{
//            [YFToast showMessage:baseModel.message inView:self.superVC.view];
//        }
//    } failure:^(NSError *error) {
//
//    }];
//}

#pragma mark  重新下单
-(void)Confirmation{
    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
    [parms safeSetObject:_Omodel.taskId forKey:@"taskId"];
    [parms safeSetObject:_Omodel.Id forKey:@"id"];
    @weakify(self)
    [WKRequest getWithURLString:@"v1/taskOrder/select.do" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            YFOrderDetailModel *orderModel           = [YFOrderDetailModel mj_objectWithKeyValues:baseModel.data];
            YFReleseDetailModel *detailModel         = [YFReleseDetailModel mj_objectWithKeyValues:baseModel.data];
            detailModel.vehicleCarType               = orderModel.carType;
            detailModel.vehicleCarLength             = orderModel.carSize;
            detailModel.quotedPrice                  = orderModel.taskFee;
            detailModel.driverPhone                  = orderModel.driverMobile;
            YFPlaceOrderViewController *place        = [YFPlaceOrderViewController new];
            place.detailModel                        = detailModel;
            place.oldOrderType                       = 2;
            [self.superVC.navigationController pushViewController:place animated:YES];
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 分享到微信
- (void)shareView{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    YFShareView *shareView = [[YFShareView alloc] initWithFrame:CGRectZero shareType:YFShareContentBySourceType];
    NSString *userName;
    if (![NSString isBlankString:[UserData userInfo].username]) {
        userName = [[UserData userInfo].username substringToIndex:1];
    }else{
        userName = @"";
    }
    shareView.shareContent = [NSString stringWithFormat:@"好货好价，%@老板等你来联系！登录乾坤司机APP，优质货源等你来接。",userName];
    shareView.shareImage = @"shareIcon";
    shareView.shareTitle = [NSString stringWithFormat:@"【%@→%@】的货源寻求车辆资源",[NSString getCityName:self.Rmodel.startSite],[NSString getCityName:self.Rmodel.endSite]];
    shareView.superVC = self.superVC;
    shareView.shareUrl = [NSString stringWithFormat:@"%@?id=%@",H5_URL,self.Rmodel.Id];
    [win addSubview:shareView];
}

#pragma mark 刷新置顶
- (void)refreshTop{
    NSMutableDictionary *parms                       = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.Rmodel.Id forKey:@"id"];
    @weakify(self)
    [WKRequest getWithURLString:@"v1/goodsSource/refreshToTop.do" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            !self.refreshDataBlock ? : self.refreshDataBlock();
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}



@end
