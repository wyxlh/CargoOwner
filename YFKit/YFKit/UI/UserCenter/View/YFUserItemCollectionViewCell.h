//
//  YFUserItemCollectionViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/7/24.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFUserItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic, strong) NSDictionary *dict;
@end
