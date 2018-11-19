//
//  YFUserCenterHeadView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/9.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFPersonImageModel;
@interface YFUserCenterHeadView : UIView
@property (weak, nonatomic, nullable) IBOutlet UIImageView *imgView;
@property (weak, nonatomic, nullable) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic, nullable) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UIButton *logo;
@property (weak, nonatomic) IBOutlet UIButton *loginOrRegister;
@property (nonatomic, strong, nullable) UIImageView *pictureImageView;
@property (nonatomic, strong, nullable) YFPersonImageModel *model;
@property (nonatomic, strong, nullable) YFBaseViewController *superVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navH;
@end
