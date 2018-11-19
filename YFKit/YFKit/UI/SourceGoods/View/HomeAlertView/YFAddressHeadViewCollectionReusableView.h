//
//  YFAddressHeadViewCollectionReusableView.h
//  YFKit
//
//  Created by 王宇 on 2018/5/24.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFAddressHeadViewCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArr;
@property (weak, nonatomic) IBOutlet UIButton *dissperBtn;
/**
 返回 tag
 */
@property (nonatomic, copy) void(^clickcChooseAddressBlock)(NSInteger);

/**
  改变 button 的选中状态

 @param tag  tag
 */
-(void)updataBtnBackgroundColorWithTag:(NSInteger)tag;
@end
