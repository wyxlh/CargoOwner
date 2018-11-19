//
//  YFUserCenterCollectionViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/6/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFUserCenterCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *cancelNum;
@property (nonatomic, strong, nullable) NSDictionary *dict;
@end
