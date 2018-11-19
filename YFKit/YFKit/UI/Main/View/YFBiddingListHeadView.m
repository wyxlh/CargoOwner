//
//  YFBiddingListHeadView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/4.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFBiddingListHeadView.h"
#import "YFBiddingListModel.h"
@implementation YFBiddingListHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)setModel:(YFBiddingListModel *)model{
    self.orderNum.text = [NSString stringWithFormat:@"货源单号 : %@",model.supplyGoodsId];
    self.counting = [NSString getSecond:self.publishedTime Minute:model.placeTime];
    if ([NSString isCanOffer:self.publishedTime Minute:model.placeTime]) {
        self.time.hidden = NO;
        if (_timer == nil){
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimeCounting) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
        [_timer fire];
    }else{
        self.time.hidden = YES;
    }
}


#pragma mark - 定时器倒计时
- (void)TimeCounting
{
    self.counting--;
    self.time.text = [NSString getMMSSFromSS:[NSString stringWithFormat:@"%ld",self.counting]];
    if (self.counting == 0)
    {
        [_timer invalidate];
        _timer = nil;
        self.time.hidden = YES;
        [YFNotificationCenter postNotificationName:@"RefreshBidDataKey" object:nil];
    }
    
}

//全部
- (IBAction)clickAllBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    !self.callBackSortBlock ? : self.callBackSortBlock(sender.tag,YES);
}
//时间
- (IBAction)clickTimeBtn:(UIButton *)sender {
    self.priceBtn.selected = NO;
    sender.selected = !sender.selected;
    !self.callBackSortBlock ? : self.callBackSortBlock(sender.tag,sender.selected);
}
//价格
- (IBAction)clickPriceBtn:(UIButton *)sender {
    self.timeBtn.selected = NO;
    sender.selected = !sender.selected;
    !self.callBackSortBlock ? : self.callBackSortBlock(sender.tag,sender.selected);
}
@end
