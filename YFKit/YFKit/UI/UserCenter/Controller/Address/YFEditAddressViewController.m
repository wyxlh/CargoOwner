//
//  YFEditAddressViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFEditAddressViewController.h"
#import "YFChooseAddressView.h"
@interface YFEditAddressViewController ()
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UITextField *detailTF;
@property (nonatomic, copy) NSString *receiverCity,*cityCode;
@property (nonatomic, strong) YFChooseAddressView *addressView;
@end

@implementation YFEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                            = self.isEdit ? @"修改地址" : @"新建地址";
    SKViewsBorder(self.submitBtn, 4, 0, NavColor);
    self.view.backgroundColor             = UIColorFromRGB(0xF7F7F7);
    
    [self verification];
    
    [self assignment];
}


/**
 验证 输入框
 */
- (void)verification
{
    @weakify(self)
    [[self.nameTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *nameText                 = [NSString stringWithFormat:@"%@",x];
        if (nameText.length > 10) {
            self.nameTF.text               = [nameText substringWithRange:NSMakeRange(0, 10)];
        }
    }];
    
    [[self.phoneTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *phoneText                = [NSString stringWithFormat:@"%@",x];
        if (phoneText.length > 11) {
            self.phoneTF.text               = [phoneText substringWithRange:NSMakeRange(0, 11)];
        }
    }];

    [[self.detailTF rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        NSString *detailText               = [NSString stringWithFormat:@"%@",x];
        if (detailText.length > 100) {
            self.detailTF.text               = [detailText substringWithRange:NSMakeRange(0, 100)];
        }
    }];
}



/**
 编辑地址 重新复制
 */
- (void)assignment{
    if (self.aModel && !self.isConsignor) {
        self.nameTF.text                            = self.aModel.receiverContacts;
        self.phoneTF.text                           = self.aModel.receiverMobile;
        self.cityTF.text                            = self.aModel.receiverCity;
        self.detailTF.text                          = self.aModel.receiverAddr;
        self.cityCode                               = self.aModel.siteCode;
    }else if (self.Cmodel && self.isConsignor){
        self.nameTF.text                            = self.Cmodel.consignerContacts;
        self.phoneTF.text                           = self.Cmodel.consignerMobile;
        self.cityTF.text                            = self.Cmodel.consignerCity;
        self.detailTF.text                          = self.Cmodel.consignerAddr;
        self.cityCode                               = self.Cmodel.siteCode;
    }
}



#pragma mark 选择地址
- (IBAction)chooseAddress:(id)sender {
    [self.view endEditing:YES];
    self.addressView.hidden                         = NO;
    [self.addressView resetData];
    [UIView animateWithDuration:0.25 animations:^{
        self.addressView.backgroundColor            = [UIColor colorWithWhite:0.00 alpha:0.299];
        self.addressView.y                          = -500;
    }];
}

#pragma mark addressView
-(YFChooseAddressView *)addressView{
    if (!_addressView) {
        _addressView                            = [[[NSBundle mainBundle] loadNibNamed:@"YFChooseAddressView" owner:nil options:nil] lastObject];
        _addressView.frame                      = CGRectMake(0, 0, ScreenWidth, ScreenHeight + 500);
        @weakify(self)
        _addressView.chooseDetailAddressBlock   = ^(NSString *addressStr,NSString *addressCode){
            @strongify(self)
            self.cityTF.text                    = addressStr;
            self.cityCode                       = [NSString getCityCode:addressCode];
        };
        [YFWindow addSubview:_addressView];
    }
    return _addressView;
}

- (IBAction)clickSubmit:(id)sender {
    
    NSString *alertMsg;
    if ([NSString isBlankString:self.nameTF.text]) {
        alertMsg                                = @"请输入真实姓名";
    }else if (![NSString validateMobile:self.phoneTF.text]){
        alertMsg                                = @"请输入正确的手机号";
    }else if ([NSString isBlankString:self.cityTF.text]){
        alertMsg                                = @"请选择地区";
    }else if (!self.isConsignor && [NSString isBlankString:self.detailTF.text]){
        alertMsg                                = @"请输入详细地址";
    }
    
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.view];
        return;
    }
    
    NSMutableDictionary *parms                  = [NSMutableDictionary dictionary];
    if (self.isConsignor) {
        [parms safeSetObject:self.cityTF.text forKey:@"consignerCity"];
        [parms safeSetObject:self.cityCode forKey:@"siteCode"];
        [parms safeSetObject:self.detailTF.text forKey:@"consignerAddr"];
        if (self.isEdit) {
            [parms safeSetObject:self.Cmodel.Id forKey:@"id"];
        }
        [parms safeSetObject:self.phoneTF.text forKey:@"consignerMobile"];
        [parms safeSetObject:self.nameTF.text forKey:@"consignerContacts"];
    }else{
        [parms safeSetObject:self.cityTF.text forKey:@"receiverCity"];
        [parms safeSetObject:self.cityCode forKey:@"siteCode"];
        [parms safeSetObject:self.detailTF.text forKey:@"receiverAddr"];
        if (self.isEdit) {
            [parms safeSetObject:self.aModel.Id forKey:@"id"];
        }
        [parms safeSetObject:self.phoneTF.text forKey:@"receiverMobile"];
        [parms safeSetObject:self.nameTF.text forKey:@"receiverContacts"];
    }
    
    
    NSString *path                              = self.isConsignor ? @"userConsigner/addOrUpdSenderInfo.do" : @"userReceiver/addOrUpdReceiverInfo.do";
    
    @weakify(self)
    [WKRequest postWithURLString:path parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [YFToast showMessage:self.isEdit ? @"修改成功" : @"添加成功" inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
