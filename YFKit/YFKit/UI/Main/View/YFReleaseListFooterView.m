//
//  YFHistoryListFooterView.m
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFReleaseListFooterView.h"
#import "YFLookSignInViewController.h"
#import "YFBiddingListViewController.h"
#import "YFReleseListModel.h"
#import "YFOrderListModel.h"
#import "YFReleseDetailModel.h"
#import "YFAdjFreeAlertView.h"
#import "YFOrderDetailModel.h"
@implementation YFReleaseListFooterView

-(void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self.leftBtn, 2, 0, NavColor);
    SKViewsBorder(self.rightBtn, 2, 0, NavColor);
    SKViewsBorder(self.countLbl, 6.5, 0, NavColor);
}


/**
货源列表的数据赋值
 */
-(void)setRmodel:(YFReleseListModel *)Rmodel{
    _Rmodel                           = Rmodel;
    self.countLbl.text                = _Rmodel.priceCount;
    
    if (self.type == 1) {
        self.leftBtn.hidden           = self.rightBtn.hidden = self.countLbl.hidden = NO;
        
        if ([Rmodel.priceCount integerValue] == 0) {
            self.rightBtn.backgroundColor = UIColorFromRGB(0x98999A);
            self.rightBtn.userInteractionEnabled = NO;
        }else{
            self.rightBtn.backgroundColor = UIColorFromRGB(0x0078E5);
            self.rightBtn.userInteractionEnabled = YES;
        }
        self.countLbl.hidden              = [_Rmodel.priceCount integerValue] == 0 ? YES : NO;
    }else{
        self.rightBtn.hidden          = NO;
        [self.rightBtn setTitle:@"再发一单" forState:0];
    }
    
    
    
}

/**
 订单列表的数据赋值
 */
-(void)setOmodel:(YFOrderListModel *)Omodel{
    _Omodel                               = Omodel;
    if (self.type == 1) {
        if (Omodel.taskStatus == 0) {
            self.leftBtn.hidden           = self.rightBtn.hidden = NO;
            //设置 title
            [self.leftBtn setTitle:@"取消订单" forState:0];
            [self.rightBtn setTitle:@"联系司机" forState:0];
            //设置颜色
            [self.leftBtn setBackgroundColor:UIColorFromRGB(0xF16623)];
            [self.rightBtn setBackgroundColor:UIColorFromRGB(0x0078E5)];
        }else if (Omodel.taskStatus == 1 || Omodel.taskStatus == 2 || Omodel.taskStatus == 3){
            self.rightBtn.hidden          = self.leftBtn.hidden = NO;
            //设置 title
            [self.leftBtn setTitle:@"调整运费" forState:0];
            [self.rightBtn setTitle:@"联系司机" forState:0];
            //设置颜色
            [self.leftBtn setBackgroundColor:UIColorFromRGB(0x0078E5)];
            [self.rightBtn setBackgroundColor:UIColorFromRGB(0x0078E5)];
        }else if (Omodel.taskStatus == 4){
            self.leftBtn.hidden           = self.rightBtn.hidden = self.freeBtn.hidden = NO;
            //设置 title
            [self.leftBtn setTitle:@"确认收货" forState:0];
            [self.rightBtn setTitle:@"联系司机" forState:0];
            //设置颜色
            [self.leftBtn setBackgroundColor:UIColorFromRGB(0x0078E5)];
            [self.rightBtn setBackgroundColor:UIColorFromRGB(0x0078E5)];
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
        [self.superVC showAlertViewControllerTitle:wenxinTitle Message:@"您确定要取消该货源吗?" CancelTitle:@"取消" CancelTextColor:CancelColor ConfirmTitle:@"确定" ConfirmTextColor:ConfirmColor cancelBlock:^{
            
        } confirmBlock:^{
            [weakSelf goodsCancel];
        }];
    }else if ([sender.titleLabel.text isEqualToString:@"联系司机"]){
        //联系司机
        NSString *driverMobile = [NSString stringWithFormat:@"tel:%@",self.Omodel.driverMobile];
        if (![NSString isBlankString:self.Omodel.driverMobile]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:driverMobile]];
        }else{
            [YFToast showMessage:@"该司机电话号码为空" inView:self.superVC.view];
        }
    }else if ([sender.titleLabel.text isEqualToString:@"取消订单"]){
        //取消订单
        [self.superVC showAlertViewControllerTitle:wenxinTitle Message:@"您确定要取消该订单吗?" CancelTitle:@"取消" CancelTextColor:CancelColor ConfirmTitle:@"确定" ConfirmTextColor:ConfirmColor cancelBlock:^{
            
        } confirmBlock:^{
            [weakSelf orderCancel];
        }];
    }else if ([sender.titleLabel.text isEqualToString:@"确认收货"]){
        //确认收货 因为如果说在这里发一个通知的话 会导致 在在 VC 中发通知的时候, 第二次执行 会执行两次
        [self.superVC showAlertViewControllerTitle:wenxinTitle Message:@"您是否要确认收货?" CancelTitle:@"取消" CancelTextColor:CancelColor ConfirmTitle:@"确定" ConfirmTextColor:ConfirmColor cancelBlock:^{
            
        } confirmBlock:^{
            //因需要定位 所以要把这个放到了 VC 中
            !self.confirmCollectGoodsBlock ? : self.confirmCollectGoodsBlock(weakSelf.Omodel);
        }];
        
    }else if ([sender.titleLabel.text isEqualToString:@"再发一单"]){
        [self goodDetail];
        
    }else if ([sender.titleLabel.text isEqualToString:@"调整运费"]){
        YFAdjFreeAlertView *alert = [[[NSBundle mainBundle]loadNibNamed:@"YFAdjFreeAlertView" owner:nil options:nil] lastObject];
        alert.model               = self.Omodel;
        [alert show:YES];
        alert.adjustmentFreeBlock = ^(BOOL isSuccess, NSString *msg, NSString *taskFree){
            if (isSuccess) {
                !self.refreshDataBlock ? : self.refreshDataBlock();
                [YFToast showMessage:msg inView:self.superVC.view];
            }else{
                [YFToast showMessage:msg inView:self.superVC.view];
            }
        };
        [YFWindow addSubview:alert];
    }else if ([sender.titleLabel.text isEqualToString:@"重新下单"]){
        [self Confirmation];
    }
}

#pragma mark 货源取消
-(void)goodsCancel{
    NSMutableDictionary *parms                        = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.Rmodel.Id forKey:@"id"];
    @weakify(self)
    [WKRequest postWithURLString:@"v1/goods/cancle.do" parameters:parms isJson:YES success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            !self.refreshDataBlock ? : self.refreshDataBlock();
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 订单取消
-(void)orderCancel{
    NSMutableDictionary *parms                        = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.Omodel.Id forKey:@"id"];
    [parms safeSetObject:self.Omodel.taskId forKey:@"taskId"];
    @weakify(self)
    [WKRequest postWithURLString:@"v1/taskOrder/cancleTaskOrder.do" parameters:parms isJson:YES success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            !self.refreshDataBlock ? : self.refreshDataBlock();
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 货源订单详情
-(void)goodDetail{
    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
    [parms safeSetObject:@(self.type) forKey:@"type"];
    [parms safeSetObject:_Rmodel.Id forKey:@"id"];
    NSString *path                          = [NSString stringWithFormat:@"v1/goods/%ld/get.do",(long)self.type];
    @weakify(self)
    [WKRequest getWithURLString:path parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [YFNotificationCenter postNotificationName:@"AgainOrder" object:[YFReleseDetailModel mj_objectWithKeyValues:baseModel.data]];
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark  调整运费
-(void)adjustmentFree{
    NSMutableDictionary *parms              = [NSMutableDictionary dictionary];
    [parms safeSetObject:_Omodel.taskId forKey:@"taskId"];
    [parms safeSetObject:_Omodel.Id forKey:@"id"];
    [parms safeSetObject:@"300" forKey:@"addAmount"];
    [parms safeSetObject:@"1" forKey:@"remark"];
    @weakify(self)
    [WKRequest postWithURLString:@"v1/taskOrder/addCount.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
         @strongify(self)
        if (CODE_ZERO) {
            
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

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
            
            [YFNotificationCenter postNotificationName:@"Reorder" object:detailModel];

        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
        
    } failure:^(NSError *error) {
        
    }];
}



@end
