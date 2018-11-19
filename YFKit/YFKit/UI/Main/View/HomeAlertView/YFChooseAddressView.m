//
//  YFChooseAddressView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/24.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFChooseAddressView.h"
#import "YFItemCollectionViewCell.h"
#import "YFCarTypeModel.h"
#import "YFAddressHeadViewCollectionReusableView.h"
#import "LineView.h"
@implementation YFChooseAddressView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap              = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.delegate                             = self;
    [self addGestureRecognizer:tap];
    [self setUI];
    
    
}

-(void)setUI{
    self.selectIndex                         = 0;
    NSArray *ProvinceArr                     = [NSArray readLocalFileWithName:@"Province"];
    self.proArr                              = [YFChooseAddressModel mj_objectArrayWithKeyValuesArray:ProvinceArr];
    
    NSDictionary *CityArr                    = (NSDictionary *)[NSArray readLocalFileWithName:@"CityArea"];
    self.AllCityDict                         = CityArr;
    
    UICollectionViewFlowLayout *flowlayout   = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.scrollDirection               = UICollectionViewScrollDirectionVertical;
    flowlayout.minimumLineSpacing            = 5;
    flowlayout.minimumInteritemSpacing       = 5;
    self.collectionView.delegate             = self;
    self.collectionView.dataSource           = self;
    self.collectionView.collectionViewLayout = flowlayout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFItemCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YFAddressHeadViewCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFAddressHeadViewCollectionReusableView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LineView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LineView"];
}

#pragma mark  UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.selectIndex == 0) {
        
        return self.proArr.count;
        
    }else if (self.selectIndex == 1){
        
        return self.cityArr.count;
        
    }else if (self.selectIndex == 2){
        
        return self.areaArr.count;
        
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YFItemCollectionViewCell *cell      = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFItemCollectionViewCell" forIndexPath:indexPath];
    
    if (self.selectIndex == 0) {
        cell.AddressModel               = self.proArr[indexPath.row];
    }else if (self.selectIndex == 1){
        cell.AddressModel               = self.cityArr[indexPath.row];
    }else if (self.selectIndex == 2){
        cell.AddressModel               = self.areaArr[indexPath.row];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-45)/4,35);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return section == 0 ? UIEdgeInsetsMake(0, 15, 0, 15) : UIEdgeInsetsZero;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        __weak YFAddressHeadViewCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFAddressHeadViewCollectionReusableView" forIndexPath:indexPath];
        headView.tag                                      = 100;
        @weakify(self)
        [[headView.dissperBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self disappear];
        }];
        
        headView.clickcChooseAddressBlock                   = ^(NSInteger tag){
            @strongify(self)
            if (tag != 0) {
                if (self.cityArr.count == 0) {
                    [YFToast showMessage:@"请选择省" inView:self.collectionView];
                    [headView updataBtnBackgroundColorWithTag:0];
                    return;
                }else if(self.areaArr.count == 0 && tag != 1){
                    [YFToast showMessage:@"请选择市" inView:self.collectionView];
                    [headView updataBtnBackgroundColorWithTag:1];
                    return;
                }
            }
            
            self.selectIndex                                = tag;
            [self.collectionView reloadData];
        };
        
        return headView;
    }
    LineView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LineView" forIndexPath:indexPath];
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(ScreenWidth, 92);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex ++;
    if (self.selectIndex == 1) {
        for (YFChooseAddressModel *model in self.proArr) {
            model.isSelect                   = NO;
        }
        YFChooseAddressModel *model          = self.proArr[indexPath.row];
        model.isSelect                       = YES;
        self.selectProName                   = model.address;
        //拿到城市的数据
        NSDictionary *cityDict               = [self.AllCityDict safeJsonObjForKey:model.code];
        
        NSMutableArray *cityArr              = [NSMutableArray new];
        //城市codeArr
        NSArray *cityCodeArr                 = cityDict.mj_keyValues.allKeys;
        //城市名字Arr
        NSArray *nameArr                     = cityDict.mj_keyValues.allValues;
        for (int i = 0; i < cityCodeArr.count; i ++) {
            NSMutableDictionary *cityDic         = [NSMutableDictionary dictionary];
            [cityDic safeSetObject:nameArr[i] forKey:@"address"];
            [cityDic safeSetObject:cityCodeArr[i] forKey:@"code"];
            [cityDic safeSetObject:@(0) forKey:@"isSelect"];
            [cityArr addObject:cityDic];
        }
        
        self.cityArr                         = [YFChooseAddressModel mj_objectArrayWithKeyValuesArray:cityArr];
        
    }else if (self.selectIndex == 2){
        for (YFChooseAddressModel *model in self.cityArr) {
            model.isSelect                   = NO;
        }
        YFChooseAddressModel *model          = self.cityArr[indexPath.row];
        model.isSelect                       = YES;
        self.selectCityName                  = model.address;
        
        // 区的数据
        NSDictionary *districtDict = [self.AllCityDict safeJsonObjForKey:model.code];
        
        NSMutableArray *areaArr              = [NSMutableArray new];
        //区codeArr
        NSArray *areaCodeArr                 = districtDict.mj_keyValues.allKeys;
        //区名字Arr
        NSArray *areaNameArr                 = districtDict.mj_keyValues.allValues;
        //给每个区添加全市的选项
        [areaArr addObject:[self addAllCity]];
        for (int i = 0; i < areaCodeArr.count; i ++) {
            NSMutableDictionary *areaDic     = [NSMutableDictionary dictionary];
            [areaDic safeSetObject:areaNameArr[i] forKey:@"address"];
            [areaDic safeSetObject:areaCodeArr[i] forKey:@"code"];
            [areaDic safeSetObject:@(0) forKey:@"isSelect"];
            [areaArr addObject:areaDic];
        }
        
        self.areaArr                         = [YFChooseAddressModel mj_objectArrayWithKeyValuesArray:areaArr];
        
    }else if (self.selectIndex == 3){
        for (YFChooseAddressModel *model in self.areaArr) {
            model.isSelect                   = NO;
        }
        YFChooseAddressModel *model          = self.areaArr[indexPath.row];
        model.isSelect                       = YES;
        self.selectAreaName                  = [model.address isEqualToString:@"全市"] ? @"" : model.address;
    }
    
    if (self.selectIndex < 3) {
        //更改头视图的选中状态
        YFAddressHeadViewCollectionReusableView *headView = [self viewWithTag:100];
        [headView updataBtnBackgroundColorWithTag:self.selectIndex];
    }else{
        NSString *detailAddressStr;
        if ([NSString isBlankString:self.selectAreaName]) {
            detailAddressStr                 = [NSString stringWithFormat:@"%@/%@",self.selectProName,self.selectCityName];
        }else{
            detailAddressStr                 = [NSString stringWithFormat:@"%@/%@/%@",self.selectProName,self.selectCityName,self.selectAreaName];
        }
        
        !self.chooseDetailAddressBlock ? : self.chooseDetailAddressBlock(detailAddressStr);
        [self disappear];
    }
    
    [self.collectionView reloadData];
}


//给每个区添加全市的选项
-(NSMutableDictionary *)addAllCity{
    NSMutableDictionary *AllCity            = [NSMutableDictionary dictionary];
    [AllCity safeSetObject:@"全市" forKey:@"address"];
    [AllCity safeSetObject:@"10" forKey:@"code"];
    [AllCity safeSetObject:@(0) forKey:@"isSelect"];
    return AllCity;
}

-(NSMutableArray *)cityArr{
    
    if (!_cityArr) {
        _cityArr                             = [NSMutableArray new];
    }
    return _cityArr;
}
-(NSMutableArray *)areaArr{
    
    if (!_areaArr) {
        _areaArr                             = [NSMutableArray new];
    }
    return _areaArr;
}

-(NSMutableArray *)proArr{
    if (!_proArr) {
        _proArr                              = [NSMutableArray new];
    }
    return _proArr;
    
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

/**
 重置
 */
-(void)resetData{
    if (self.selectIndex != 0) {
        self.selectIndex                         = 0;
        NSArray *ProvinceArr                     = [NSArray readLocalFileWithName:@"Province"];
        self.proArr                              = [YFChooseAddressModel mj_objectArrayWithKeyValuesArray:ProvinceArr];
        
        NSDictionary *CityArr                    = (NSDictionary *)[NSArray readLocalFileWithName:@"CityArea"];
        self.AllCityDict                         = CityArr;
        
        [self.cityArr removeAllObjects];
        [self.areaArr removeAllObjects];
        
        YFAddressHeadViewCollectionReusableView *headView = [self viewWithTag:100];
        [headView updataBtnBackgroundColorWithTag:self.selectIndex];
        
        [self.collectionView reloadData];
    }
    
}
@end
