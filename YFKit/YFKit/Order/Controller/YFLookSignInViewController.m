//
//  YFLookSignInViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFLookSignInViewController.h"

@interface YFLookSignInViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderNum;//订单号
@property (weak, nonatomic) IBOutlet UILabel *signPeople;//签收人
@property (weak, nonatomic) IBOutlet UILabel *signTime;//签收时间
@property (weak, nonatomic) IBOutlet UILabel *signType;//签收类型
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;

@end

@implementation YFLookSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.title                          = @"查看签收";
    SKViewsBorder(self.leftImgView, 2, 0, NavColor);
    SKViewsBorder(self.leftImgView, 2, 0, NavColor);
}

#pragma mark netWork
-(void)netWork{
    NSMutableDictionary *parms           = [NSMutableDictionary dictionary];
    [parms safeSetObject:self.taskId forKey:@"taskId"];
    @weakify(self)
    [WKRequest getWithURLString:@"" parameters:parms success:^(WKBaseModel *baseModel) {
        @strongify(self)
        if (CODE_ZERO) {
            
        }
    } failure:^(NSError *error) {
        
    }];
}



@end
