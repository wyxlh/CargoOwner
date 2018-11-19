//
//  YFAddressFooterView.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFAddressFooterView.h"
#import "YFEditAddressViewController.h"
#import "YFAddressModel.h"
@implementation YFAddressFooterView

-(void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self.leftBtn, 3, 0.5, UIColorFromRGB(0x747474));
    SKViewsBorder(self.rightBtn, 3, 0.5, UIColorFromRGB(0x747474));
}

- (IBAction)clickBtn:(UIButton *)sender {
    WS(weakSelf)
    if ([sender.titleLabel.text containsString:@"编辑"]) {
        YFEditAddressViewController *edit           = [YFEditAddressViewController new];
        edit.isConsignor                            = self.isConsignor;
        edit.isEdit                                 = YES;
        if (self.isConsignor) {
            edit.Cmodel                             = self.Cmodel;
        }else{
            edit.aModel                             = self.model;
        }
        [self.superVC.navigationController pushViewController:edit animated:YES];
    }else if ([sender.titleLabel.text containsString:@"删除"]){
        [self.superVC showAlertViewControllerTitle:@"" Message:@"您确定要删除该地址吗?" CancelTitle:@"取消" CancelTextColor:CancelColor ConfirmTitle:@"确定" ConfirmTextColor:ConfirmColor cancelBlock:^{
            
        } confirmBlock:^{
            [weakSelf deleteAddress];
        }];
    }else if ([sender.titleLabel.text containsString:@"默认地址"]){
        [self defaultAddress];
    }
}

-(void)setModel:(YFAddressModel *)model{
    _model                                          = model;
    self.defaultBtn.selected                        = model.isDefault;
}

-(void)setCmodel:(YFConsignerModel *)Cmodel{
    _Cmodel                                         = Cmodel;
    self.defaultBtn.selected                        = Cmodel.isDefault;
}

#pragma mark 删除地址
- (void)deleteAddress{
    NSMutableDictionary *parms                       = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.isConsignor ? self.Cmodel.Id : self.model.Id forKey:@"id"];
    NSString *path                                   = self.isConsignor ? @"userConsigner/delete.do" :@"userReceiver/delete.do";
    @weakify(self)
    [WKRequest getWithURLString:path parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            !self.refreshBlock ? : self.refreshBlock();
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark  设置默认地址
- (void)defaultAddress{
    NSMutableDictionary *parms                       = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.isConsignor ? self.Cmodel.Id : self.model.Id forKey:@"id"];
    NSString *path                                   = self.isConsignor ? @"userConsigner/defaultAddr.do" :@"userReceiver/defaultAddr.do";
    @weakify(self)
    [WKRequest getWithURLString:path parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            !self.refreshBlock ? : self.refreshBlock();
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
