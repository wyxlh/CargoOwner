//
//  YFResetPassWordViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFResetPassWordViewController.h"

@interface YFResetPassWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPswTF;
@property (weak, nonatomic) IBOutlet UITextField *savePswTF;
@property (weak, nonatomic) IBOutlet UITextField *NewTF;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *resetHeadView;

@end

@implementation YFResetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                       = @"重置密码";
    [self.view sendSubviewToBack:self.resetHeadView];
    self.view.backgroundColor        = UIColorFromRGB(0xF7F7F7);
    SKViewsBorder(self.saveBtn, 3, 0, NavColor);
}
- (IBAction)clickSaveBtn:(id)sender {
    [self.view endEditing:YES];
    NSString *alertMsg;
    if ([NSString isBlankString:self.oldPswTF.text]) {
        alertMsg                    = @"请输入原密码";
    }else if ([NSString isBlankString:self.NewTF.text]){
        alertMsg                    = @"请输入新密码";
    }else if ([NSString isBlankString:self.savePswTF.text]){
        alertMsg                    = @"请输入确认密码";
    }else if (![self.NewTF.text isEqualToString:self.savePswTF.text]){
        alertMsg                    = @"两次密码不一致";
    }else if (![self.NewTF.text weakPswd]){
        alertMsg                    = @"请输入6-15位字母 + 数字";
    }
    
    if (alertMsg.length != 0) {
        [YFToast showMessage:alertMsg inView:self.view];
        return;
    }
    
    NSMutableDictionary *parms      = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.oldPswTF.text forKey:@"oripwd"];
    [parms safeSetObject:self.NewTF.text forKey:@"newpwd"];
    [parms safeSetObject:self.savePswTF.text forKey:@"repwd"];
    @weakify(self)
    [WKRequest postWithURLString:@"user/modifypwd.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [YFToast showMessage:@"修改成功" inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

//原密码
- (IBAction)oldBtnClick:(UIButton *)sender {
    sender.selected                 = !sender.selected;
    self.oldPswTF.secureTextEntry   = !sender.selected;
}
//新密码
- (IBAction)newBtnClick:(UIButton *)sender {
    sender.selected                 = !sender.selected;
    self.NewTF.secureTextEntry      = !sender.selected;
}
//确认新密码
- (IBAction)completeBtnClick:(UIButton *)sender {
    sender.selected                 = !sender.selected;
    self.savePswTF.secureTextEntry  = !sender.selected;
}

@end
