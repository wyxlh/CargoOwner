//
//  YFUserCenterService.m
//  YFKit
//
//  Created by 王宇 on 2018/6/7.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFUserCenterService.h"
#import "YFUserCenterCollectionViewCell.h"
#import "YFUserItemCollectionViewCell.h"
#import "YFUserCenterCollectionReusableView.h"
@implementation YFUserCenterService

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.viewModel.dataArr.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.viewModel.dataArr[section] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YFUserCenterCollectionViewCell *cell        = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFUserCenterCollectionViewCell" forIndexPath:indexPath];
        cell.dict                                   = self.viewModel.dataArr[indexPath.section][indexPath.row];
        if (indexPath.row != 2) {
            cell.cancelNum.hidden                   = YES;
        }else{
            cell.cancelNum.hidden                   = [YFOfferData shareInstace].cancelOrderSuccessCount == 0;
        }
        return cell;
    }
    YFUserItemCollectionViewCell *cell              = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFUserItemCollectionViewCell" forIndexPath:indexPath];
    cell.dict                                       = self.viewModel.dataArr[indexPath.section][indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake((ScreenWidth)/3, ScreenWidth/4);
    }
    return CGSizeMake(ScreenWidth, 48);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        YFUserCenterCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFUserCenterCollectionReusableView" forIndexPath:indexPath];
        headView.title.text                          = indexPath.section == 0 ? @"我的订单" : @"";
        return headView;
    }
    return [UICollectionReusableView new];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return section == 1 ? CGSizeMake(ScreenWidth, 5) : CGSizeMake(ScreenWidth, 40.0f);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 2) {
        //点击已取消之后, 小圆点消失掉
        YFUserCenterCollectionViewCell *cell = (YFUserCenterCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.cancelNum.hidden = YES;
        [YFOfferData shareInstace].cancelOrderSuccessCount = 0;
    }
    [self.viewModel jumpCtrlWithSelectSection:indexPath.section SelectIndex:indexPath.row];
}




@end
