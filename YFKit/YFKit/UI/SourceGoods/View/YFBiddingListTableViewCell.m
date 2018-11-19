//
//  YFBiddingListTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBiddingListTableViewCell.h"
#import "YFBiddingListModel.h"
@implementation YFBiddingListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.time.adjustsFontSizeToFitWidth = YES;
    SKViewsBorder(self.saveBtn, 2, 0, NavColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(PriceListModel *)model{
    _model           = model;
    if (!model.isCanOffer) {
        self.saveBtn.backgroundColor = UIColorFromRGB(0x98999A);
        self.saveBtn.userInteractionEnabled = NO;
    }else{
        self.saveBtn.backgroundColor = UIColorFromRGB(0x0078E5);
        self.saveBtn.userInteractionEnabled = YES;
    }
    self.name.text   = [NSString stringWithFormat:@"%@    交易次数  %@次",[NSString getNullOrNoNull:model.carrierName],model.transactionCount];
    self.time.text   = [NSString stringWithFormat:@"报价时间 : %@",[NSString getNullOrNoNull:model.quoteTime]];
    
    self.money.text  = [NSString stringWithFormat:@"报价金额 : %@元",[NSString getNullOrNoNull:model.quotePrice]];
    
}

- (IBAction)clickBidBtn:(id)sender {
    [self verificationIsCanOffer];
}

/**
 验证是否能确认报价
 */
- (void)verificationIsCanOffer{
    NSMutableDictionary *parms                = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.model.Id forKey:@"id"];
    @weakify(self)
    [WKRequest isHiddenActivityView:YES];
    [WKRequest getWithURLString:@"v1/supply/goods/quote/count.do" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            BOOL isNotHave                    = [[[baseModel.mDictionary safeJsonObjForKey:@"data"] safeJsonObjForKey:@"isNotHave"] boolValue];
            if (isNotHave) {
                [self.superVC showAlertViewControllerTitle:wenxinTitle Message:@"您确定要报价吗?" CancelTitle:@"取消" CancelTextColor:CancelColor ConfirmTitle:@"确定" ConfirmTextColor:ConfirmColor cancelBlock:^{
                    
                } confirmBlock:^{
                    !self.callBackBlock ? : self.callBackBlock ();
                }];
            }else{
                [YFToast showMessage:@"司机已取消报价"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.superVC.navigationController popViewControllerAnimated:YES];
                });
            }
        }else{
            [YFToast showMessage:baseModel.message inView:self.superVC.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
