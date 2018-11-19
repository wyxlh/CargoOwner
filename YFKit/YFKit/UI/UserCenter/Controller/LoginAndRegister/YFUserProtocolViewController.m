//
//  YFUserProtocolViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/28.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFUserProtocolViewController.h"

@interface YFUserProtocolViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, copy) NSString *url;
@end

@implementation YFUserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                          = @"用户协议";
    [self netWork];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark netWork
-(void)netWork{
    @weakify(self)
    [WKRequest getWithURLString:@"register/readme.do" parameters:nil success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            self.url                    = [NSString stringWithFormat:@"%@",baseModel.data];
            [self getUserProtocolContent];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)getUserProtocolContent{
    @weakify(self)
    [WKRequest getRegisterWithURLString:self.url parameters:nil success:^(NSString *content) {
        @strongify(self)
        self.textView.text             = content;
    } failure:^(NSError *error) {
        
    }];
}

@end
