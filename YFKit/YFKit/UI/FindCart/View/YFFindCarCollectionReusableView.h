//
//  YFFindCarCollectionReusableView.h
//  YFKit
//
//  Created by 王宇 on 2018/6/25.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFFindCarCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *emptyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;
@property (nonatomic, assign) BOOL isStart;//出发地
@property (nonatomic, assign) NSInteger section;
@end
