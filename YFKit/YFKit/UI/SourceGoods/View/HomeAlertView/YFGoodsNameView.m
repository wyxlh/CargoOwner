//
//  YFGoodsNameView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFGoodsNameView.h"
#import "YFItemCollectionViewCell.h"
#import "YFItemHeadCollectionReusableView.h"
#import "LineView.h"
#import "YFHomeInputCollectionViewCell.h"
#import "YFCarTypeModel.h"
@implementation YFGoodsNameView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    [self setUI];
}

-(void)setUI{
    self.goodsNamesArr                          = [YFCarTypeModel mj_objectArrayWithKeyValuesArray:[NSArray getGoodsName]];
    
    UICollectionViewFlowLayout *flowlayout      = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.scrollDirection                  = UICollectionViewScrollDirectionVertical;
    flowlayout.minimumLineSpacing               = 5;
    flowlayout.minimumInteritemSpacing          = 5;
    self.collectionView.delegate                = self;
    self.collectionView.dataSource              = self;
    self.collectionView.collectionViewLayout    = flowlayout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFItemCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFHomeInputCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFHomeInputCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFItemHeadCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFItemHeadCollectionReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LineView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LineView"];
    
}

-(void)refresh{
    for (YFCarTypeModel *model in self.goodsNamesArr) {
        model.isSelect      = NO;
    }
    
    self.goodsNames         = self.otherTF.text = @"";
    
     YFHomeInputCollectionViewCell *cell = (YFHomeInputCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
     cell.textField.text     = @"";
    
     [self.collectionView reloadData];
    
}

#pragma mark  UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section == 0 ? self.goodsNamesArr.count : 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YFItemCollectionViewCell *cell      = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFItemCollectionViewCell" forIndexPath:indexPath];
        cell.model                          = self.goodsNamesArr[indexPath.row];
        return cell;
    }
    YFHomeInputCollectionViewCell *cell     = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFHomeInputCollectionViewCell" forIndexPath:indexPath];
    self.otherTF                            = cell.textField;
    @weakify(self)
    [[self.otherTF rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(id x) {
        @strongify(self)
        self.heightCons.constant            = 480.0f;
        
    }];
    
    [[self.otherTF rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(id x) {
        @strongify(self)
        self.heightCons.constant            = 250.0f;
    }];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? CGSizeMake((ScreenWidth-47)/4,35) : CGSizeMake(ScreenWidth, 44);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return section == 0 ? UIEdgeInsetsMake(0, 16, 0, 16) : UIEdgeInsetsZero;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        YFItemHeadCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFItemHeadCollectionReusableView" forIndexPath:indexPath];
        headView.title.text               = indexPath.section == 0 ? @"请选择货品" : @"";
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
    
    return section == 0 ? CGSizeMake(ScreenWidth, 50) : CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return section == 1 ? CGSizeZero : CGSizeMake(ScreenWidth, 13);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YFHomeInputCollectionViewCell *cell = (YFHomeInputCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.textField.text     = @"";
    
    if (indexPath.section == 0) {
        if (self.selectIndex == indexPath.row) {
            //这么做是为了可以取消选中
            YFCarTypeModel *model   = self.goodsNamesArr[indexPath.row];
            model.isSelect          = !model.isSelect;
            self.goodsNames         = model.isSelect ? model.name : @"";
        }else{
            //货品名称
            for (YFCarTypeModel *model in self.goodsNamesArr) {
                model.isSelect      = NO;
            }
            YFCarTypeModel *model = self.goodsNamesArr[indexPath.row];
            model.isSelect          = YES;
            self.goodsNames         = model.name;
        }
        self.selectIndex            = indexPath.row;
    }
    [self.collectionView reloadData];
    [self clickSaveBtn:nil];
}

#pragma mark - 让视图消失的方法
//解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    CGPoint point = [touch locationInView:self];
//    if (point.y < ScreenHeight) {
//        return YES;
//    }
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
    [self disappear];
    
    NSString *goodsName = [NSString getCarMessageWithFirst:self.goodsNames AndSecond:self.otherTF.text];
    
    if ([NSString isBlankString:goodsName]) {
        return;
    }
    
    !self.callBackCarTypeBlock ? : self.callBackCarTypeBlock(goodsName);
    
}
@end
