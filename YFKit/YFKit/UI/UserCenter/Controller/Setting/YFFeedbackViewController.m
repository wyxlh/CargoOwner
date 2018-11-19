//
//  YFFeedbackViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFFeedbackViewController.h"

@interface YFFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation YFFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                      = @"意见反馈";
    SKViewsBorder(self.saveBtn, 3, 0, NavColor);
    SKViewsBorder(self.bgView, 2, 0.6, UIColorFromRGB(0xEDECED));
    self.view.backgroundColor       = UIColorFromRGB(0xF7F7F7);
    [[self.detailTextView rac_textSignal] subscribeNext:^(id x) {
        if ([NSString isBlankString:x]) {
            self.placeholder.hidden = NO;
        }else{
            self.placeholder.hidden = YES;
        }
    }];
}

- (IBAction)clickSaveBtn:(id)sender {
    
    if ([NSString isBlankString:self.titleTF.text]) {
        [YFToast showMessage:@"请输入您要反馈的主要内容" inView:self.view];
        return;
    }else if ([NSString isBlankString:self.detailTextView.text]){
        [YFToast showMessage:@"请输入您要反馈详细内容" inView:self.view];
        return;
    }
    
    NSMutableDictionary *parms      = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.titleTF.text forKey:@"title"];
    [parms safeSetObject:self.detailTextView.text forKey:@"content"];
    @weakify(self)
    [WKRequest postWithURLString:@"system/feedback.do" parameters:parms isJson:NO success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            [YFToast showMessage:@"提交成功" inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [YFToast showMessage:baseModel.message inView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

@end
