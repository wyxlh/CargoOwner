//
//  YFCartTypeView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFCartTypeView.h"
#import "YFItemCollectionViewCell.h"
#import "YFItemHeadCollectionReusableView.h"
#import "LineView.h"
@implementation YFCartTypeView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUI];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

-(void)setUI{
    self.typeArr                                = [NSArray getCartType];
    self.lengthArr                              = [NSArray getCarLength];
    
    UICollectionViewFlowLayout *flowlayout      = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.scrollDirection                  = UICollectionViewScrollDirectionVertical;
    flowlayout.minimumLineSpacing               = 5;
    flowlayout.minimumInteritemSpacing          = 5;
    flowlayout.itemSize                         = CGSizeMake((ScreenWidth-25)/4,40);
    flowlayout.sectionInset                     = UIEdgeInsetsMake(0, 5, 0, 5);
    self.collectionView.delegate                = self;
    self.collectionView.dataSource              = self;
    self.collectionView.collectionViewLayout    = flowlayout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFItemCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFItemHeadCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFItemHeadCollectionReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LineView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LineView"];

}

#pragma mark  UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section == 0 ? self.typeArr.count : self.lengthArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YFItemCollectionViewCell *cell      = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFItemCollectionViewCell" forIndexPath:indexPath];
    cell.title.text                     = indexPath.section == 0 ? self.typeArr[indexPath.row] : self.lengthArr[indexPath.row];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        YFItemHeadCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFItemHeadCollectionReusableView" forIndexPath:indexPath];
        return headView;
    }
    LineView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LineView" forIndexPath:indexPath];
    return view;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(ScreenWidth, 50);
}

#pragma mark - 让视图消失的方法
//解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self];
    if (point.y < ScreenHeight) {
        return YES;
    }
    return NO;
}

- (void)tapClick:(UITapGestureRecognizer*)tap
{
    [self disappear];
}

- (void)disappear
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.y = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

#pragma mark 取消
- (IBAction)clickCancelBtn:(id)sender {
    [self disappear];
}
#pragma mark  确定
- (IBAction)clickSaveBtn:(id)sender {
    
}

@end
