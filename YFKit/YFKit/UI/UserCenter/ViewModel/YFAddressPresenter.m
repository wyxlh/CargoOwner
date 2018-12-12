//
//  YFAddressPresenter.m
//  YFKit
//
//  Created by 王宇 on 2018/12/11.
//  Copyright © 2018 wy. All rights reserved.
//

#import "YFAddressPresenter.h"
#import "YFAddressDataTool.h"
#import "YFEditAddressViewController.h"

@implementation YFAddressPresenter

#pragma mark 得到所有view需要的最终数据
- (NSString *)name {
    return self.model.receiverContacts;
}

- (NSString *)address {
    return [NSString stringWithFormat:@"%@%@",self.model.receiverCity,[NSString getNullOrNoNull:self.model.receiverAddr]];
}

- (NSString *)phone {
    return self.model.receiverMobile;
}

- (BOOL)isDefault {
    return self.model.isDefault;
}

#pragma mark 绑定数据
- (void)bindToCell:(YFAddressListTableViewCell *)cell {
    cell.name.text    = self.name;
    cell.address.text = self.address;
    cell.phone.text   = self.phone;
}

- (void)bindToFooterView:(YFAddressFooterView *)footerView {
    footerView.defaultBtn.selected = self.isDefault;
}

#pragma mark 处理 footerView 的按钮逻辑方法
- (void)handleFooterViewButton:(YFBaseViewController *)baseVC
             buttonTitleString:(NSString *)buttonTitleString
                   isConsignor:(BOOL)isConsignor
                   resultBlock:(void(^)(void))resultBlock {
    
    if ([buttonTitleString containsString:@"默认地址"]) {
        [[YFAddressDataTool shareInstance] setDefaultAddressId:self.model.Id addressType:isConsignor ? YFSendAddressType : YFReceiverAddressType successBlock:^{
            resultBlock();
        }];
        
    }else if ([buttonTitleString containsString:@"删除"]) {
        [baseVC showAlertViewControllerTitle:@"" Message:@"您确定要删除该地址吗?" CancelTitle:@"取消" CancelTextColor:CancelColor ConfirmTitle:@"确定" ConfirmTextColor:ConfirmColor cancelBlock:^{
            
        } confirmBlock:^{
            [[YFAddressDataTool shareInstance] setDeleteAddressId:self.model.Id addressType:isConsignor ? YFSendAddressType : YFReceiverAddressType successBlock:^{
                resultBlock();
            }];
        }];
    }else if ([buttonTitleString containsString:@"编辑"]) {
        YFEditAddressViewController *edit           = [YFEditAddressViewController new];
        edit.isConsignor                            = isConsignor;
        edit.isEdit                                 = YES;
        edit.aModel                                 = self.model;
        [baseVC.navigationController pushViewController:edit animated:YES];
    }
}



@end
