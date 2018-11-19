//
//  YFLookImgItemCollectionViewCell.h
//  YFKit
//
//  Created by 王宇 on 2018/5/11.
//  Copyright © 2018年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YFLookImgItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, copy) NSString *path;
@end
