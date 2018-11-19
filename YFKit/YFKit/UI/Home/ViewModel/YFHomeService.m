//
//  YFHomeService.m
//  YFKit
//
//  Created by 王宇 on 2018/6/13.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFHomeService.h"
#import "YFHomeCollectionViewCell.h"
#import "YFHomePostCollectionViewCell.h"
@implementation YFHomeService


#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section == 0 ? 1 : [self.viewModel.titleArr count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YFHomePostCollectionViewCell *cell   = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFHomePostCollectionViewCell" forIndexPath:indexPath];
        WS(weakSelf)
        cell.callBackBtnTagBlock             = ^(NSInteger tag){
            [weakSelf.viewModel jumpCtrlWithSelectSection:indexPath.section SelectIndex:tag];
        };
        return cell;
    }
    YFHomeCollectionViewCell *cell           = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFHomeCollectionViewCell" forIndexPath:indexPath];
    cell.title.text                          = self.viewModel.titleArr[indexPath.row];
    cell.logo.image                          = [UIImage imageNamed:self.viewModel.imgArr[indexPath.row]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat scale                        = 750.0f/190;
        CGFloat height                       = ScreenWidth/scale;
        return CGSizeMake(ScreenWidth, IS_IPHONE6P ? height : 100);
    }
    CGFloat scale                            = 750.0f/180.0f;
    CGFloat height                           = ScreenWidth/scale;
    return CGSizeMake((ScreenWidth-3)/3, height);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return section == 0 ? CGSizeZero : CGSizeMake(ScreenWidth, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [self.viewModel jumpCtrlWithSelectSection:indexPath.section SelectIndex:indexPath.row];
    }
}


@end
