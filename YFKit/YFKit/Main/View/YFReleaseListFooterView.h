//
//  YFHistoryListFooterView.h
//  YFKit
//
//  Created by 王宇 on 2018/4/30.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFReleseListModel;
@interface YFReleaseListFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
/**
 主要是判断哪个页面使用了这个footer不同的footer 按钮上面的字不同
 */
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIViewController *superVC;
@property (nonatomic, strong) YFReleseListModel *Rmodel;
@end
