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
    self.typeArr                                = [YFCarTypeModel mj_objectArrayWithKeyValuesArray:[NSArray getCartType]];
    self.lengthArr                              = [YFCarTypeModel mj_objectArrayWithKeyValuesArray:[NSArray getCarLength]];
    
    UICollectionViewFlowLayout *flowlayout      = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.scrollDirection                  = UICollectionViewScrollDirectionVertical;
    flowlayout.minimumLineSpacing               = 5;
    flowlayout.minimumInteritemSpacing          = 5;
    flowlayout.itemSize                         = CGSizeMake((ScreenWidth-50)/4,35);
    flowlayout.sectionInset                     = UIEdgeInsetsMake(0, 10, 0, 10);
    self.collectionView.delegate                = self;
    self.collectionView.dataSource              = self;
    self.collectionView.collectionViewLayout    = flowlayout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFItemCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFItemHeadCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFItemHeadCollectionReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LineView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LineView"];

}

 //刷新
-(void)refresh{
    for (YFCarTypeModel *model in self.typeArr) {
        model.isSelect      = NO;
    }
    
    for (YFCarTypeModel *model in self.lengthArr) {
        model.isSelect      = NO;
    }
    [self.collectionView reloadData];
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
    cell.model                          = indexPath.section == 0 ? self.typeArr[indexPath.row] : self.lengthArr[indexPath.row];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        YFItemHeadCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFItemHeadCollectionReusableView" forIndexPath:indexPath];
        headView.title.font               = [UIFont boldSystemFontOfSize:15];
        headView.title.text               = indexPath.section == 0 ? @"请选择车型" : @"请选择车长";
        headView.cancelBtn.hidden         = indexPath.section == 1;
        WS(weakSelf)
        headView.clickCancenBlock         = ^{
            [weakSelf disappear];
        };
        return headView;
    }
    LineView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LineView" forIndexPath:indexPath];
    return view;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(ScreenWidth, 50);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.selectTypeIndex == indexPath.row) {
            //这么做是为了可以取消选中
            YFCarTypeModel *model   = self.typeArr[indexPath.row];
            model.isSelect          = !model.isSelect;
            self.carType            = model.isSelect ? model.name : @"";
        }else{
            //车型单选
            for (YFCarTypeModel *model in self.typeArr) {
                model.isSelect      = NO;
            }
            YFCarTypeModel *model = self.typeArr[indexPath.row];
            model.isSelect          = YES;
            self.carType            = model.name;
        }
        self.selectTypeIndex        = indexPath.row;
    }else{
        if (self.selectLengthIndex == indexPath.row) {
            //这么做是为了可以取消选中
            YFCarTypeModel *model   = self.lengthArr[indexPath.row];
            model.isSelect          = !model.isSelect;
            self.carlength          = model.isSelect ? model.name : @"";
        }else{
            //车长单选
            for (YFCarTypeModel *model in self.lengthArr) {
                model.isSelect      = NO;
            }
            YFCarTypeModel *model   = self.lengthArr[indexPath.row];
            model.isSelect          = YES;
            self.carlength          = model.name;
        }
        
        self.selectLengthIndex  = indexPath.row;
    }
    [self.collectionView reloadData];
}

#pragma mark - 让视图消失的方法
//解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self];
    if (point.y < ScreenHeight) {
        [self getData];
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
    if ([NSString isBlankString:self.carType]) {
        [YFToast showMessage:@"请选择车型" inView:self.collectionView];
        return;
    }else if ([NSString isBlankString:self.carlength]){
        [YFToast showMessage:@"请选择车长" inView:self.collectionView];
        return;
    }
    [self disappear];
    [self getData];
    
}

-(void)getData{
    self.carType = [NSString isBlankString:self.carType] ? @"" : self.carType;
    
    self.carlength = [NSString isBlankString:self.carlength] ? @"" : self.carlength;
    
    !self.callBackCarTypeBlock ? : self.callBackCarTypeBlock(self.carType, self.carlength);
}

@end