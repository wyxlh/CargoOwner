//
//  YFViolationBannerTableViewCell.m
//  YFKit
//
//  Created by 王宇 on 2018/6/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFViolationBannerTableViewCell.h"
#import <SDCycleScrollView.h>
@implementation YFViolationBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    NSArray *_imageUrls = @[@"http://ww4.sinaimg.cn/bmiddle/a15bd3a5jw1f12r9ku6wjj20u00mhn22.jpg",
                            @"http://ww2.sinaimg.cn/bmiddle/a15bd3a5jw1f01hkxyjhej20u00jzacj.jpg",
                            @"http://ww4.sinaimg.cn/bmiddle/a15bd3a5jw1f01hhs2omoj20u00jzwh9.jpg",
                            @"http://ww2.sinaimg.cn/bmiddle/a15bd3a5jw1ey1oyiyut7j20u00mi0vb.jpg",];
    
    SDCycleScrollView *cycleScrollView         = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth,124) delegate:nil placeholderImage:[UIImage imageNamed:@"fang"]];
    cycleScrollView.pageControlAliment         = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.clickItemOperationBlock    = ^(NSInteger currentIndex) {
       
    };
    cycleScrollView.currentPageDotColor        = NavColor; // 自定义分页控件小圆标颜色
    cycleScrollView.imageURLStringsGroup      = _imageUrls;
    cycleScrollView.hidden                    = _imageUrls.count == 0 ? YES : NO ;
    [self.bannerBgView addSubview:cycleScrollView];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
