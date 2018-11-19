//
//  YFUserCenterHeadView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/9.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFUserCenterHeadView.h"
#import "YFPersonImageModel.h"
#import "YFPersonalMsgViewController.h"

@implementation YFUserCenterHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.navH.constant = ISIPHONEX ? 15 + XHEIGHT : 20;
    self.name.text = [UserData userInfo].username;
//
    _pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 175)];
    _pictureImageView.image = [UIImage imageNamed:@"userCenterBg"];
    _pictureImageView.backgroundColor = NavColor;
    /*
     重要的属性设置
     */
    //这个属性的值决定了 当视图的几何形状变化时如何复用它的内容 这里用 UIViewContentModeScaleAspectFill 意思是保持内容高宽比 缩放内容 超出视图的部分内容会被裁减 填充UIView
    _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    // 这个属性决定了子视图的显示范围 取值为YES时，剪裁超出父视图范围的子视图部分.这里就是裁剪了_pictureImageView超出_header范围的部分.
    _pictureImageView.clipsToBounds = YES;

    [self addSubview:_pictureImageView];
    [self sendSubviewToBack:_pictureImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        KUSERNOTLOGIN
        YFPersonalMsgViewController *person      = [YFPersonalMsgViewController new];
        person.hidesBottomBarWhenPushed          = YES;
        [self.superVC.navigationController pushViewController:person animated:YES];
        
    }];
    [self.imgView addGestureRecognizer:tap];
    
    [[self.loginOrRegister rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        KUSERNOTLOGIN
    }];
}

-(void)setModel:(YFPersonImageModel *)model{
    if (isLogin) {
        self.name.hidden = self.phone.hidden = self.logo.hidden = NO;
        self.loginOrRegister.hidden = YES;
        self.name.text = model.realName;
        self.phone.text = model.mobile;
    }else{
        self.name.hidden = self.phone.hidden = self.logo.hidden = YES;
        self.loginOrRegister.hidden = NO;
    }
    
    
    //0为待审核，1为审核通过，2审核不通过
//    if (model.auditStatus  == 0) {
//    }else if (model.auditStatus == 1){
//    }else if (model.auditStatus == 2){
//    }
}

@end
