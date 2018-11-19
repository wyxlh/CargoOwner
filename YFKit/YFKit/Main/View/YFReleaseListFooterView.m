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
@implementation YFReleaseListFooterView

-(void)awakeFromNib{
    [super awakeFromNib];
    SKViewsBorder(self.leftBtn, 2, 0, NavColor);
    SKViewsBorder(self.rightBtn, 2, 0, NavColor);
    SKViewsBorder(self.countLbl, 6.5, 0, NavColor);
}

-(void)setRmodel:(YFReleseListModel *)Rmodel{
    _Rmodel                           = Rmodel;
    self.countLbl.text                = _Rmodel.priceCount;
    self.countLbl.hidden              = [_Rmodel.priceCount integerValue] == 0 ? YES : NO;
}


-(void)setIndex:(NSInteger)index{
    if (index == 1) {
        self.leftBtn.hidden           = self.rightBtn.hidden = self.countLbl.hidden = NO;
    }else if (index == 3){
        self.leftBtn.hidden           = self.rightBtn.hidden = NO;
        [self.leftBtn setTitle:@"取消订单" forState:0];
        [self.rightBtn setTitle:@"联系司机" forState:0];
    }else if (index == 4){
        self.rightBtn.hidden          = NO;
        [self.rightBtn setTitle:@"查看签收单" forState:0];
    }else{
        self.rightBtn.hidden          = NO;
        [self.rightBtn setTitle:@"再发一单" forState:0];
    }
}
#pragma mark 按钮点击 这里是根据title来判断执行什么操作
- (IBAction)clickBtn:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"查看签收单"]) {
        YFLookSignInViewController *look             = [[YFLookSignInViewController alloc]initWithNibName:@"YFLookSignInViewController" bundle:nil];
        look.hidesBottomBarWhenPushed                = YES;
        [self.superVC.navigationController pushViewController:look animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"查看报价"]){
        YFBiddingListViewController *list            = [YFBiddingListViewController new];
        list.hidesBottomBarWhenPushed                = YES;
        list.Id                                      = _Rmodel.Id;
        [self.superVC.navigationController pushViewController:list animated:YES];
    }
}


@end
