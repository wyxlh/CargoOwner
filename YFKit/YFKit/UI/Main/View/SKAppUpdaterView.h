//
//  SKAppUpdaterView.h
//  SKKit
//
//  Created by maxin on 2017/6/2.
//  Copyright © 2017年 maxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKAppUpdaterView : UIView

/**
 更新的文本描述
 */
@property (nonatomic,copy) NSString *content;
@property (strong, nonatomic) IBOutlet UIButton *UpdateButton;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *baView;


@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *oneUpdataBtn;

@end
