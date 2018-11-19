//
//  YFOtherRequirementView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/8.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFOtherRequirementView.h"
#import "YFItemCollectionViewCell.h"
#import "YFItemHeadCollectionReusableView.h"
#import "LineView.h"
#import "YFOtherInputCollectionViewCell.h"
#import "YFCarTypeModel.h"
@implementation YFOtherRequirementView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap              = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.delegate                             = self;
    [self addGestureRecognizer:tap];
    [self setUI];
}

-(void)setUI{
    self.RequireArr                          = [YFCarTypeModel mj_objectArrayWithKeyValuesArray:[NSArray getOtherRequirement]];
    
    UICollectionViewFlowLayout *flowlayout   = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.scrollDirection               = UICollectionViewScrollDirectionVertical;
    flowlayout.minimumLineSpacing            = 10;
    flowlayout.minimumInteritemSpacing       = 10;
    self.collectionView.delegate             = self;
    self.collectionView.dataSource           = self;
    self.collectionView.collectionViewLayout = flowlayout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFItemCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFOtherInputCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFOtherInputCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFItemHeadCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFItemHeadCollectionReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LineView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LineView"];
}

-(void)refresh{
    for (YFCarTypeModel *model in self.RequireArr) {
        model.isSelect      = NO;
    }
    
    [self.collectionView reloadData];
}

#pragma mark  UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section == 0 ? self.RequireArr.count : 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YFItemCollectionViewCell *cell      = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFItemCollectionViewCell" forIndexPath:indexPath];
        cell.model                          = self.RequireArr[indexPath.row];
        return cell;
    }
    YFOtherInputCollectionViewCell *cell    = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFOtherInputCollectionViewCell" forIndexPath:indexPath];
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
    return indexPath.section == 0 ? CGSizeMake((ScreenWidth-62)/4,35) : CGSizeMake(ScreenWidth, 35);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return section == 0 ? UIEdgeInsetsMake(0, 16, 0, 16) : UIEdgeInsetsZero;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        YFItemHeadCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFItemHeadCollectionReusableView" forIndexPath:indexPath];
        headView.title.text               = indexPath.section == 0 ? @"装卸要求" : @"备注";
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
        if (self.selectIndex == indexPath.row) {
            //这么做是为了可以取消选中
            YFCarTypeModel *model   = self.RequireArr[indexPath.row];
            model.isSelect          = !model.isSelect;
            self.otherRequire       = model.isSelect ? model.name : @"";
        }else{
            //车型单选
            for (YFCarTypeModel *model in self.RequireArr) {
                model.isSelect      = NO;
            }
            YFCarTypeModel *model = self.RequireArr[indexPath.row];
            model.isSelect          = YES;
            self.otherRequire       = model.name;
        }
        self.selectIndex            = indexPath.row;
    }
    [self.collectionView reloadData];
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
    [self disappear];
    
    if ([NSString isBlankString:self.otherRequire] && [NSString isBlankString:self.otherTF.text]) {
        return;
    }
    !self.callBackCarTypeBlock ? : self.callBackCarTypeBlock(self.otherRequire,self.otherTF.text);
    
}

@end
