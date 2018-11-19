//
//  YFSourceAddressScreeneView.m
//  YFKit
//
//  Created by 王宇 on 2018/8/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSourceAddressScreeneView.h"
#import "YFItemCollectionViewCell.h"
#import "YFCarTypeItemCollectionViewCell.h"
#import "YFFindCarCollectionReusableView.h"
#import "YFCarTypeModel.h"

@implementation YFSourceAddressScreeneView

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.isStart ? 0 : self.selctEndArr.count;
    }else if (section == 1){
        return self.isStart ? self.historyStartArr.count : self.historyEndArr.count;
    }else{
        if (self.selectIndex == 0) {
            
            return self.isStart ? self.startProArr.count : self.endProArr.count;
            
        }else if (self.selectIndex == 1){
            
            return self.cityArr.count;
            
        }else if (self.selectIndex == 2){
            
            return self.areaArr.count;
            
        }
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        //总的数据
        YFItemCollectionViewCell *cell                  = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFItemCollectionViewCell" forIndexPath:indexPath];
        cell.selectIndex                                = self.selectIndex;
        cell.selectRow                                  = self.isStart ? 100 : indexPath.row;
        if (self.selectIndex == 0) {
            cell.AddressModel                           = self.isStart ? self.startProArr[indexPath.row] : self.endProArr[indexPath.row];
        }else if (self.selectIndex == 1){
            cell.AddressModel                           = self.cityArr[indexPath.row];
        }else if (self.selectIndex == 2){
            cell.AddressModel                           = self.areaArr[indexPath.row];
        }
        return cell;
    }
    //选中的和历史选中
    YFCarTypeItemCollectionViewCell *cell               = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFCarTypeItemCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.addressModel                               = self.isStart ? self.selectStartArr[indexPath.row] : self.selctEndArr[indexPath.row];
        cell.deleteImg.hidden                           = NO;
    }else if (indexPath.section == 1) {
        cell.addressModel                               = self.isStart ? self.historyStartArr[indexPath.row] : self.historyEndArr[indexPath.row];
        cell.deleteImg.hidden                           = YES;
    }
    @weakify(self)
    cell.deleteSelectItemBlock                          = ^{
        @strongify(self)
        [self deleteSelectCarMessage:indexPath.row];
    };
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        YFFindCarCollectionReusableView *headView       = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFFindCarCollectionReusableView" forIndexPath:indexPath];
        headView.isStart                                = self.isStart;
        headView.section                                = indexPath.section;
        if ((indexPath.section == 0 && self.selctEndArr.count != 0)||indexPath.section == 2) {
            headView.emptyBtn.hidden                    = NO;
        }else{
            headView.emptyBtn.hidden                    = YES;
        }
        headView.title.text                             = [NSArray getChooseAddressHeadTitleArr][indexPath.section];
        @weakify(self)
        [[[headView.emptyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:headView.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            @strongify(self)
            UIButton *btn                               = (UIButton *)x;
            if ([btn.titleLabel.text containsString:@"清空"]) {
                [self.selctEndArr removeAllObjects];
                [self.completeEndArr removeAllObjects];
                for (YFChooseAddressModel *model in self.areaArr) {
                    model.isSelect                      = NO;
                }
            }else{
                if (self.selectIndex == 0) {
                    [YFToast showMessage:@"已经是最上一级了" inView:self];
                    return;
                }
                 self.selectIndex --;
            }
            [self.collectionView reloadData];
        }];
        return headView;
    }
    return [UICollectionReusableView new];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.isStart) {
        return section == 0 ? CGSizeZero : CGSizeMake(ScreenWidth, 40.0f);
    }
    return CGSizeMake(ScreenWidth, 40.0f);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.isStart) {
        return section == 0 ? UIEdgeInsetsZero : UIEdgeInsetsMake(0, 10, 15, 10);
    }
    return UIEdgeInsetsMake(0, 10, 15, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (self.selectIndex == 0) {
            self.selectProIndex                       = indexPath.row;
            for (YFChooseAddressModel *model in self.isStart ? self.startProArr : self.endProArr) {
                model.isSelect                        = NO;
            }
            //得到省名
            YFChooseAddressModel *model               = self.isStart ? self.startProArr[indexPath.row] : self.endProArr[indexPath.row];
            model.isSelect                            = YES;
            self.selectProName                        = [model.address isEqualToString:@"全国"] ? @"" : model.address;
            if (self.selectProName.length == 0) {
                [self.selctEndArr removeAllObjects];
                [self.completeEndArr removeAllObjects];
                [self clickSaveBtn:nil];
                return;
            }
            NSDictionary *CityArr                     = (NSDictionary *)[NSArray readLocalFileWithName:@"CityArea"];
            //拿到城市的数据
            NSDictionary *cityDict                    = [CityArr safeJsonObjForKey:model.code];
            NSMutableArray *cityArr                   = [NSMutableArray new];
            //城市codeArr
            NSArray *cityCodeArr                      = cityDict.mj_keyValues.allKeys;
            //城市名字Arr
            NSArray *nameArr                          = cityDict.mj_keyValues.allValues;
            [cityArr addObject:[self addAllPro]];
            for (int i = 0; i < cityCodeArr.count; i ++) {
                NSMutableDictionary *cityDic          = [NSMutableDictionary dictionary];
                [cityDic safeSetObject:nameArr[i] forKey:@"address"];
                [cityDic safeSetObject:cityCodeArr[i] forKey:@"code"];
                [cityDic safeSetObject:@(0) forKey:@"isSelect"];
                [cityArr addObject:cityDic];
            }
            self.cityArr                              = [YFChooseAddressModel mj_objectArrayWithKeyValuesArray:cityArr];
        }else if (self.selectIndex == 1){
            self.selectCityIndex                      = indexPath.row;
            //得到城市名
            YFChooseAddressModel *model               = self.cityArr[indexPath.row];
            model.isSelect                            = indexPath.row == 0 ? !model.isSelect : YES;
            self.selectCityName                       = [model.address isEqualToString:@"全省"] ? @"" : model.address;
            if (self.selectCityName.length == 0 && self.isStart) {
                model.detailAddress                   = self.selectProName;
                //得到历史选中数据
                [self updataSelectProrCityNameWithIndex:indexPath.row withDataArray:self.cityArr];
                [self clickSaveBtn:nil];
                return;
            }else if (self.selectCityName.length == 0 && !self.isStart){
                self.selectIndex                      = 0;
                //目的地点击全省
                [self chooseProvincialUrbanAreaIsDetail:NO areaAddress:@""];
                model.detailAddress                   = self.selectProName;
                if (model.isSelect) {
                    [self updataSelectProrCityNameWithIndex:indexPath.row withDataArray:self.cityArr];
                }else{
                    [self.selctEndArr removeLastObject];
                }
            }else{
                NSDictionary *CityArr                     = (NSDictionary *)[NSArray readLocalFileWithName:@"CityArea"];
                // 区的数据
                NSDictionary *districtDict                = [CityArr safeJsonObjForKey:model.code];
                NSMutableArray *areaArr                   = [NSMutableArray new];
                //区codeArr
                NSArray *areaCodeArr                      = districtDict.mj_keyValues.allKeys;
                //区名字Arr
                NSArray *areaNameArr                      = districtDict.mj_keyValues.allValues;
                //给每个区添加全市的选项
                [areaArr addObject:[self addAllCity]];
                for (int i = 0; i < areaCodeArr.count; i ++) {
                    NSMutableDictionary *areaDic          = [NSMutableDictionary dictionary];
                    [areaDic safeSetObject:areaNameArr[i] forKey:@"address"];
                    [areaDic safeSetObject:areaCodeArr[i] forKey:@"code"];
                    [areaDic safeSetObject:@(0) forKey:@"isSelect"];
                    [areaArr addObject:areaDic];
                }
                self.areaArr                              = [YFChooseAddressModel mj_objectArrayWithKeyValuesArray:areaArr];
            }
        }else if (self.selectIndex == 2){
            //得到区的名
            if (self.isStart) {
                //出发地
                for (YFChooseAddressModel *model in self.areaArr) {
                    model.isSelect                    = NO;
                }
                YFChooseAddressModel *model           = self.areaArr[indexPath.row];
                model.isSelect                        = YES;
                
                self.selectAreaName                   = [model.address isEqualToString:@"全市"] ? @"" : model.address;
                if ([model.address isEqualToString:@"全市"]) {
                    model.detailAddress               = [NSString stringWithFormat:@"%@/%@",self.selectProName,self.selectCityName];
                }else{
                    model.detailAddress               = [NSString stringWithFormat:@"%@/%@/%@",self.selectProName,self.selectCityName,model.address];
                }
                DLog(@"-----------%@",model.detailAddress);
                //得到历史选中数据
                [self updataSelectProrCityNameWithIndex:indexPath.row withDataArray:self.areaArr];
            }else{
                //目的地
                if (!self.selctEndArr) {
                    self.selctEndArr                      = [NSMutableArray new];
                }
                if (indexPath.row == 0) {
                    //点击全市的时候
                    for (YFChooseAddressModel *model in self.areaArr) {
                        model.isSelect                = NO;
                    }
                    YFChooseAddressModel *model       = self.areaArr[indexPath.row];
                    model.isSelect                    = YES;
                    model.detailAddress               = [NSString stringWithFormat:@"%@/%@",self.selectProName,self.selectCityName];
                    //点击全市的时候 需要添加市到selctEndArr里面去
                    [self.selctEndArr removeAllObjects];
                    [self.selctEndArr addObject:self.cityArr[self.selectCityIndex]];
                    //移除重复数据
                    NSMutableArray *selctEndlistAry   = [[NSMutableArray alloc]init];
                    for (NSString *str in self.selctEndArr) {
                        if (![selctEndlistAry containsObject:str]) {
                            [selctEndlistAry addObject:str];
                        }
                    }
                    self.selctEndArr = selctEndlistAry;
                    //规定只能选择4个.
                    if (self.selctEndArr.count > 4) {
                        YFChooseAddressModel *lastModel  = self.areaArr[indexPath.row];
                        lastModel.isSelect               =  NO;
                        [self.selctEndArr removeLastObject];
                        [YFToast showMessage:@"最多只能选择4个" inView:self];
                    }
                    self.selectAreaName               = @"";
                    [self.completeEndArr removeAllObjects];
                    //组合省市区
                    [self chooseProvincialUrbanAreaIsDetail:NO areaAddress:@""];
                }else{
                    YFChooseAddressModel *zeroModel   = self.areaArr[0];
                    zeroModel.isSelect                = NO;
                    
                    YFChooseAddressModel *model       = self.areaArr[indexPath.row];
                    model.isSelect                    = !model.isSelect;
                    model.detailAddress               = [NSString stringWithFormat:@"%@/%@/%@",self.selectProName,self.selectCityName,model.address];
                    //组合选中的区名
                    for (YFChooseAddressModel *selectModel in self.areaArr) {
                        if (selectModel.isSelect) {
                            [self.selctEndArr addObject:selectModel];
                        }
                    }
                    //移除重复数据
                    NSMutableArray *selctEndlistAry   = [[NSMutableArray alloc]init];
                    for (NSString *str in self.selctEndArr) {
                        if (![selctEndlistAry containsObject:str]) {
                            [selctEndlistAry addObject:str];
                        }
                    }
                    [self.selctEndArr removeAllObjects];
                    [self.selctEndArr addObjectsFromArray:selctEndlistAry];
                    //规定只能选择4个.
                    if (self.selctEndArr.count > 4) {
                        YFChooseAddressModel *lastModel  = self.areaArr[indexPath.row];
                        lastModel.isSelect               =  NO;
                        [self.selctEndArr removeLastObject];
                        [YFToast showMessage:@"最多只能选择4个" inView:self];
                    }else{
                        //组合省市区
                        [self chooseProvincialUrbanAreaIsDetail:NO areaAddress:model.address];
                    }
                    //取消点击 刷新 section = 0 数据
                    for (YFChooseAddressModel *deleteModel in selctEndlistAry) {
                        if ([model.address isEqualToString:deleteModel.address] && !deleteModel.isSelect) {
                            [self.selctEndArr removeObject:deleteModel];
                        }
                    }
                    //组合省市区
                    NSMutableArray *selectAreaNameArr    = [NSMutableArray new];
                    NSMutableArray *listAry              = [NSMutableArray new];
                    for (YFChooseAddressModel *nameModel in self.selctEndArr) {
                        [selectAreaNameArr addObject:nameModel.address];
                        NSString *detailName             = [NSString stringWithFormat:@"%@/%@/%@",self.selectProName,self.selectCityName,nameModel.address];
                        [listAry addObject:detailName];
                    }
                    self.selectAreaName                  = [selectAreaNameArr componentsJoinedByString:@","];
                }
            }
            DLog(@"%ld",self.selectIndex);
            self.isStart ? [self clickSaveBtn:nil] : nil;
            DLog(@"%@---%@---%@",self.selectProName,self.selectCityName,self.selectAreaName);
        }
        self.selectIndex ++;
        self.selectIndex                                 = self.selectIndex > 2 ? 2 : self.selectIndex;
    }else if (indexPath.section == 1){
        if (self.isStart) {
            YFChooseAddressModel *model                  = self.historyStartArr[indexPath.row];
            self.selectProName                           = model.detailAddress;
            //把下面两个字段自为空 避免选择了目的地在来选择出发地 出现 bug
            self.selectCityName                          = self.selectAreaName = @"";
            [self clickSaveBtn:nil];
        }else{
            //目的地
            if (!self.selctEndArr) {
                self.selctEndArr                           = [NSMutableArray new];
            }
            YFChooseAddressModel *model                    = self.historyEndArr[indexPath.row];
            [self.selctEndArr addObject:model];
            //如果之前没有4条数据 添加之后超过4个需要把最后一个移除掉
            if (self.selctEndArr.count >4) {
                [YFToast showMessage:@"最多只能选择4个" inView:self];
                [self.selctEndArr removeLastObject];
            }
            self.selectProName                              = model.address;
            [self.completeEndArr addObject:model.detailAddress];
        }
    }
    [self.collectionView reloadData];
}

/**
 选择全省或者全市的时候需要存入他的上一级
 */
- (void)updataSelectProrCityNameWithIndex:(NSInteger)index withDataArray:(NSMutableArray *)dataArray{
    NSMutableArray *marray                    = @[].mutableCopy;
    [marray addObjectsFromArray:dataArray];
    //储存历史选择数据
    YFChooseAddressModel *hisModel            = [[YFChooseAddressModel alloc]init];
    YFChooseAddressModel *oldModel            = marray[index];
    hisModel.isSelect                         = oldModel.isSelect;
    hisModel.code                             = oldModel.code;
    if ([oldModel.address isEqualToString:@"全省"]) {
        hisModel.address                      =  hisModel.detailAddress = self.selectProName;
    }else if ([oldModel.address isEqualToString:@"全市"]){
        hisModel.address                      = self.selectCityName;
        hisModel.detailAddress                = [NSString stringWithFormat:@"%@/%@",self.selectProName,self.selectCityName];
    }else{
        hisModel.address                      = oldModel.address;
        hisModel.detailAddress                = oldModel.detailAddress;
    }
    if (self.isStart) {
        if (!self.selectStartArr) {
            self.selectStartArr                   = [NSMutableArray new];
        }
        //如果选择的是全市, 需要把 model 值改为他的省名
        [self.selectStartArr addObject:hisModel];
    }else{
        if (!self.selctEndArr) {
            self.selctEndArr                      = [NSMutableArray new];
        }
        //如果选择的是全市, 需要把 model 值改为他的省名
        [self.selctEndArr addObject:hisModel];
    }
    
}
/**
 选中的省市区
 */
- (void)chooseProvincialUrbanAreaIsDetail:(BOOL)isDetail areaAddress:(NSString *)areaAddress{
    if (isDetail) {
        //删除
        //定义一个数据等于completeEndArr 因为遍历的
        NSMutableArray *contentArr = [NSMutableArray arrayWithCapacity:0];
        [contentArr addObjectsFromArray:self.completeEndArr];
        for (NSString *address in contentArr) {
            if ([address containsString:areaAddress]) {
                //如果address 包含 areaAddress 那么需要删除这条数据
                [self.completeEndArr removeObject:address];
            }
        }
    }else if (!self.isStart){
        //选中了全省直接添加
        if ([NSString isBlankString:self.selectCityName]) {
            [self.completeEndArr addObject:self.selectProName];
        }else{
            NSString *address;
            if ([NSString isBlankString:areaAddress]) {
                //选中了全市直接添加
                address = [NSString stringWithFormat:@"%@/%@",self.selectProName,self.selectCityName];
                [self.completeEndArr addObject:address];
            }else{
                //选到了区
                address = [NSString stringWithFormat:@"%@/%@/%@",self.selectProName,self.selectCityName,areaAddress];
                BOOL contain = [self.completeEndArr containsObject:address];
                contain ? [self.completeEndArr removeObject:address] : [self.completeEndArr addObject:address];
            }
            //移除重复数据
            NSMutableArray *selctEndlistAry   = [[NSMutableArray alloc]init];
            for (NSString *str in self.completeEndArr) {
                if (![selctEndlistAry containsObject:str]) {
                    [selctEndlistAry addObject:str];
                }
            }
            self.completeEndArr = selctEndlistAry;
        }
    }
}

//给每个区添加全身的选项
-(NSMutableDictionary *)addAllCountry{
    NSMutableDictionary *allCountry                         = [NSMutableDictionary dictionary];
    [allCountry safeSetObject:@"全国" forKey:@"address"];
    [allCountry safeSetObject:@"10" forKey:@"code"];
    [allCountry safeSetObject:@(0) forKey:@"isSelect"];
    return allCountry;
}

//给每个区添加全身的选项
-(NSMutableDictionary *)addAllPro{
    NSMutableDictionary *allPro                            = [NSMutableDictionary dictionary];
    [allPro safeSetObject:@"全省" forKey:@"address"];
    [allPro safeSetObject:@"20" forKey:@"code"];
    [allPro safeSetObject:@(0) forKey:@"isSelect"];
    return allPro;
}

//给每个区添加全市的选项
-(NSMutableDictionary *)addAllCity{
    NSMutableDictionary *allCity                             = [NSMutableDictionary dictionary];
    [allCity safeSetObject:@"全市" forKey:@"address"];
    [allCity safeSetObject:@"30" forKey:@"code"];
    [allCity safeSetObject:@(0) forKey:@"isSelect"];
    return allCity;
}

#pragma mark 删除已选中的
- (void)deleteSelectCarMessage:(NSInteger)index{
    //拿到当前需要删除的这条数据 到总的数据源里面去遍历 修改对应数据的选中状态
    if (self.isStart) {
        YFChooseAddressModel *selectModel                   = self.selectStartArr[index];
        for (YFChooseAddressModel *model in self.startProArr) {
            if ([selectModel.address isEqualToString:model.address]) {
                model.isSelect                              = NO;
            }
        }
        //移除选中的数据
        [self.selectStartArr removeObjectAtIndex:index];
    }else{
        YFChooseAddressModel *selectModel                   = self.selctEndArr[index];
        for (YFChooseAddressModel *model in self.areaArr) {
            if ([selectModel.address isEqualToString:model.address]) {
                model.isSelect                              = NO;
            }
        }
        //也有可能是选择的全省
        for (YFChooseAddressModel *model in self.cityArr) {
            if ([selectModel.address isEqualToString:self.selectProName]) {
                model.isSelect                              = NO;
            }
        }
         //点击了全市(区的上一级)
        if ([selectModel.address isEqualToString:self.selectCityName]) {
            YFChooseAddressModel *selectAllModel            = self.areaArr[0];
            selectAllModel.isSelect                         = NO;
        }
        //移除选中的数据
        [self.selctEndArr removeObjectAtIndex:index];
        
        NSMutableArray *listAry                             = [NSMutableArray new];
        for (YFChooseAddressModel *nameModel in self.selctEndArr) {
            NSString *detailName                            = [NSString stringWithFormat:@"%@/%@/%@",self.selectProName,self.selectCityName,nameModel.address];
            [listAry addObject:detailName];
        }
        //从完整的省市区的数组中删除对应的数据
        [self chooseProvincialUrbanAreaIsDetail:YES areaAddress:selectModel.address];
    }
    [self.collectionView reloadData];
}

#pragma mark 隐藏
- (void)disappear{
    self.saveBtn.hidden                                 = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.height                                     = self.collectionView.height = 0;
    } completion:^(BOOL finished) {
        self.hidden                                     = YES;
    }];
}

#pragma mark 显示
- (void)showView{
    //初始化数据
    NSArray *ProvinceArr                                = [NSArray readLocalFileWithName:@"Province"];
    NSMutableArray *pArray                              = [NSMutableArray arrayWithCapacity:0];
    [pArray addObjectsFromArray:ProvinceArr];
    [pArray insertObject:[self addAllCountry] atIndex:0];
    if (self.isEqualSelect != self.isStart) {
        self.selectIndex                                = 0;
    }
    if (self.startProArr.count == 0 && self.isStart) {
        //出发地数据
        self.startProArr                                = [YFChooseAddressModel mj_objectArrayWithKeyValuesArray:pArray];
    }else if (self.endProArr.count == 0 && !self.isStart){
        //目的地
        self.endProArr                                  = [YFChooseAddressModel mj_objectArrayWithKeyValuesArray:pArray];
    }
    //历史数据
    if (self.isStart) {
        NSMutableArray *carTypeArr                      = [YFUserDefaults objectForKey:@"historyAddressStartArr"];
        self.historyStartArr                            = [YFChooseAddressModel mj_objectArrayWithKeyValuesArray:carTypeArr];
    }else{
        NSMutableArray *carLengthArr                    = [YFUserDefaults objectForKey:@"historyAddressEndArr"];
        self.historyEndArr                              = [YFChooseAddressModel mj_objectArrayWithKeyValuesArray:carLengthArr];
    }
    //collection fream 的变化
    self.hidden                                         = NO;
    self.collectionView.backgroundColor                 = [UIColor whiteColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.saveBtn.hidden                             = self.isStart;
        self.height                                     = ScreenHeight - NavHeight - 35 - (self.isStart ? 0 : 45);
        self.collectionView.height                      = ScreenHeight - NavHeight - 50 - 35 - (self.isStart ? 0 : 45);
    }];
    self.isEqualSelect                                  = self.isStart;
    [self.collectionView reloadData];
}

#pragma mark collectionView
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout              = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize                                 = CGSizeMake((ScreenWidth-50)/4,40);
        layout.minimumLineSpacing                       = 5;
        layout.minimumInteritemSpacing                  = 5;
        _collectionView                                 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0) collectionViewLayout:layout];
        _collectionView.delegate                        = self;
        _collectionView.dataSource                      = self;
        _collectionView.backgroundColor                 = UIColorFromRGB(0xF7F7F7);
        [_collectionView registerNib:[UINib nibWithNibName:@"YFItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFItemCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"YFCarTypeItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFCarTypeItemCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"YFFindCarCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFFindCarCollectionReusableView"];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

-(NSMutableArray *)cityArr{
    if (!_cityArr) {
        _cityArr                                        = [NSMutableArray new];
    }
    return _cityArr;
    
}

-(NSMutableArray *)areaArr{
    if (!_areaArr) {
        _areaArr                                        = [NSMutableArray new];
    }
    return _areaArr;
}

- (NSMutableArray *)completeEndArr{
    if (!_completeEndArr) {
        _completeEndArr                                  = [NSMutableArray new];
    }
    return _completeEndArr;
}

- (IBAction)clickSaveBtn:(id)sender {
    [self disappear];
    //存储搜索历史
    if (self.isStart) {
        [YFUserDefaults setObject:[NSArray saveStartAddressData:self.selectStartArr] forKey:@"historyAddressStartArr"];
        [YFUserDefaults synchronize];
    }else{
        [YFUserDefaults setObject:[NSArray saveEndAddressData:self.selctEndArr] forKey:@"historyAddressEndArr"];
        [YFUserDefaults synchronize];
    }
    NSString *address;
    if (self.selectProName.length == 0) {
        address = @"";
    }else if (self.selectCityName.length == 0) {
        address = [NSString stringWithFormat:@"%@",self.selectProName];
    }else if(self.selectAreaName.length == 0){
        address = [NSString stringWithFormat:@"%@/%@",self.selectProName,self.selectCityName];
    }else{
        address = [NSString stringWithFormat:@"%@/%@/%@",self.selectProName,self.selectCityName,self.selectAreaName];
    }
    !self.resetSelectTypeBlock ? : self.resetSelectTypeBlock(address,self.completeEndArr);
}

@end
