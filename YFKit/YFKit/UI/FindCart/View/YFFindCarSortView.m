//
//  YFFindCarSortView.m
//  YFKit
//
//  Created by 王宇 on 2018/6/25.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFFindCarSortView.h"
#import "YFItemCollectionViewCell.h"
#import "YFCarTypeItemCollectionViewCell.h"
#import "YFFindCarCollectionReusableView.h"
#import "YFCarTypeModel.h"

@implementation YFFindCarSortView

-(void)awakeFromNib{
    [super awakeFromNib];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.isCarType ? self.selectTypeArr.count : self.selctLengthArr.count;
    }else if (section == 1){
        return self.isCarType ? self.historyTypeArr.count : self.historyLengthArr.count;
    }
    return self.isCarType ? self.typeDataArr.count : self.lengthDatArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        //总的数据
        YFItemCollectionViewCell *cell                  = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFItemCollectionViewCell" forIndexPath:indexPath];
        cell.model                                  = self.isCarType ? self.typeDataArr[indexPath.row] : self.lengthDatArr[indexPath.row];
        return cell;
    }
    //选中的和历史选中
    YFCarTypeItemCollectionViewCell *cell               = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFCarTypeItemCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.model                                      = self.isCarType ? self.selectTypeArr[indexPath.row] : self.selctLengthArr[indexPath.row];
        cell.deleteImg.hidden                           = NO;
    }else if (indexPath.section == 1) {
        cell.model                                      = self.isCarType ? self.historyTypeArr[indexPath.row] : self.historyLengthArr[indexPath.row];
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
        headView.title.text                             = self.isCarType ? [NSArray ChooseCarTypeHeadArray][indexPath.section] : [NSArray ChooseCarLengthHeadArray][indexPath.section];
        if (self.isCarType && self.selectTypeArr.count != 0 && indexPath.section == 0) {
            headView.emptyBtn.hidden                    = NO;
        }else if (!self.isCarType && self.selctLengthArr.count != 0 && indexPath.section == 0){
            headView.emptyBtn.hidden                    = NO;
        }else{
            headView.emptyBtn.hidden                    = YES;
        }
        
        //清空选中
        @weakify(self)
        [[headView.emptyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if (self.isCarType) {
                //车型
                [self.selectTypeArr removeAllObjects];
                for (YFCarTypeModel *model in self.typeDataArr) {
                    model.isSelect                          = NO;
                }
            }else{
                //车长
                [self.selctLengthArr removeAllObjects];
                for (YFCarTypeModel *model in self.lengthDatArr) {
                    model.isSelect                          = NO;
                }
            }
            
            [self.collectionView reloadData];
        }];
        return headView;
    }
    return [UICollectionReusableView new];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 40.0f);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //选中不限的时候需要把其他选中转态都移除掉
            for (YFCarTypeModel *sModel in self.isCarType ? self.typeDataArr : self.lengthDatArr) {
                sModel.isSelect                        = NO;
            }
            
            YFCarTypeModel *sModel                     = self.isCarType ? self.typeDataArr[indexPath.row] : self.lengthDatArr[indexPath.row];
            sModel.isSelect                            = YES;
            if (self.isCarType) {
                [self.selectTypeArr removeAllObjects];
            }else{
                [self.selctLengthArr removeAllObjects];
            }
            [self.collectionView reloadData];
            return;
        }
        YFCarTypeModel *oneModel                       = self.isCarType ? self.typeDataArr[0] : self.lengthDatArr[0];
        oneModel.isSelect                              = NO;
        
        NSInteger selectNum                             = 0;
        YFCarTypeModel *model                           = self.isCarType ? self.typeDataArr[indexPath.row] : self.lengthDatArr[indexPath.row];
        model.isSelect                                  = !model.isSelect;
        
        //当前选中了几条数据, 最多只有4条数据
        if (self.isCarType) {
            //车型
            for (YFCarTypeModel *sModel in self.typeDataArr) {
                if (sModel.isSelect) {
                    selectNum ++;
                }
            }
        }else{
            //车长
            for (YFCarTypeModel *sModel in self.lengthDatArr) {
                if (sModel.isSelect) {
                    selectNum ++;
                }
            }
        }
        
        if (selectNum > 4) {
            //如果目前选中了4个 那个点击第五个的时候, 在上面是选中了的, 需要在这里把最后一个移除掉
            YFCarTypeModel *lastModel                   =  self.isCarType ? self.typeDataArr[indexPath.row] : self.lengthDatArr[indexPath.row];
            lastModel.isSelect                          = NO;
            [YFToast showMessage:@"最多只能选择4个" inView:self];
            return;
        }
        
        //选中数据的添加
        if (self.isCarType) {
            //车长
            self.selectTypeArr                          = [NSMutableArray new];
            for (YFCarTypeModel *selectModel in self.typeDataArr) {
                if (selectModel.isSelect) {
                    [self.selectTypeArr addObject:selectModel];
                }
            }
        }else{
            //车型
            self.selctLengthArr                          = [NSMutableArray new];
            for (YFCarTypeModel *selectModel in self.lengthDatArr) {
                if (selectModel.isSelect) {
                    [self.selctLengthArr addObject:selectModel];
                }
            }
        }
        
    }else if (indexPath.section == 1){
        if (self.isCarType) {
            //车型
            if (!self.selectTypeArr) {
                self.selectTypeArr                         = [NSMutableArray new];
            }
            YFCarTypeModel *model                          = self.historyTypeArr[indexPath.row];
            [self.selectTypeArr addObject:model];
            //如果之前没有4条数据 添加之后超过4个需要把最后一个移除掉
            if (self.selectTypeArr.count >4) {
                [self.selectTypeArr removeLastObject];
            }
            //把选中的数据在拿到远数据源里面去遍历让其选中
            NSMutableArray *hisSelectArr                   = [NSMutableArray new];
            for (YFCarTypeModel *model in self.selectTypeArr) {
                [hisSelectArr addObject:model.name];
            }
            //拿到数据之后
            for (NSString *selectStr in hisSelectArr) {
                for (int i = 0; i < self.typeDataArr.count; i++) {
                    YFCarTypeModel *model                  = self.typeDataArr[i];
                    if ([selectStr isEqualToString:model.name]) {
                        model.isSelect                     = YES;
                    }
                }
            }
        }else{
            //车长
            if (!self.selctLengthArr) {
                self.selctLengthArr                        = [NSMutableArray new];
            }
            YFCarTypeModel *model                          = self.historyLengthArr[indexPath.row];
            [self.selctLengthArr addObject:model];
            //如果之前没有4条数据 添加之后超过4个需要把最后一个移除掉
            if (self.selctLengthArr.count >4) {
                [self.selctLengthArr removeLastObject];
            }
            //把选中的数据在拿到远数据源里面去遍历让其选中
            NSMutableArray *hisSelectArr                   = [NSMutableArray new];
            for (YFCarTypeModel *model in self.selctLengthArr) {
                [hisSelectArr addObject:model.name];
            }
            //拿到数据之后
            for (NSString *selectStr in hisSelectArr) {
                for (int i = 0; i < self.lengthDatArr.count; i++) {
                    YFCarTypeModel *model                  = self.lengthDatArr[i];
                    if ([selectStr isEqualToString:model.name]) {
                        model.isSelect                     = YES;
                    }
                }
            }
        }
        
    }
    [self.collectionView reloadData];
    
}

#pragma mark 删除已选中的
- (void)deleteSelectCarMessage:(NSInteger)index{
    //拿到当前需要删除的这条数据 到总的数据源里面去遍历 修改对应数据的选中状态
    if (self.isCarType) {
        //车型
        YFCarTypeModel *selectModel                         = self.selectTypeArr[index];
        for (YFCarTypeModel *model in self.typeDataArr) {
            if ([selectModel.name isEqualToString:model.name]) {
                model.isSelect                              = NO;
            }
        }
        //移除选中的数据
        [self.selectTypeArr removeObjectAtIndex:index];
    }else{
        //车长
        YFCarTypeModel *selectModel                         = self.selctLengthArr[index];
        for (YFCarTypeModel *model in self.lengthDatArr) {
            if ([selectModel.name isEqualToString:model.name]) {
                model.isSelect                              = NO;
            }
        }
        //移除选中的数据
        [self.selctLengthArr removeObjectAtIndex:index];
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
    if (self.isCarType && self.typeDataArr.count == 0) {
        self.typeDataArr                                = [YFCarTypeModel mj_objectArrayWithKeyValuesArray:[NSArray getCartType]];
    }else if (!self.isCarType && self.lengthDatArr.count == 0){
        self.lengthDatArr                               = [YFCarTypeModel mj_objectArrayWithKeyValuesArray:[NSArray getCarLength]];
    }
    //历史数据
    if (self.isCarType) {
        NSMutableArray *carTypeArr                      = [YFUserDefaults objectForKey:@"HistoryTypeArr"];
        self.historyTypeArr                             = [YFCarTypeModel mj_objectArrayWithKeyValuesArray:carTypeArr];
    }else{
        NSMutableArray *carLengthArr                    = [YFUserDefaults objectForKey:@"HistoryLengthArr"];
        self.historyLengthArr                           = [YFCarTypeModel mj_objectArrayWithKeyValuesArray:carLengthArr];
    }
    self.hidden                                         = NO;
    self.collectionView.backgroundColor                 = [UIColor whiteColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.saveBtn.hidden                             = NO;
        self.height                                     = ScreenHeight - NavHeight - 35;
        self.collectionView.height                      = ScreenHeight - NavHeight - 50 - 35;
    }];
    [self.collectionView reloadData];
}

/**
 重置
 */
- (void)resetData{
    if (self.selectTypeArr.count != 0) {
        [self.selectTypeArr removeAllObjects];
    }
    
    for (YFCarTypeModel *model in self.typeDataArr) {
        model.isSelect                              = NO;
    }

    if (self.selctLengthArr.count != 0) {
        [self.selctLengthArr removeAllObjects];
    }
    
    for (YFCarTypeModel *model in self.lengthDatArr) {
        model.isSelect                              = NO;
    }
    [self.collectionView reloadData];
}


#pragma mark collectionView
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout              = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize                                 = CGSizeMake((ScreenWidth-50)/4,40);
        layout.minimumLineSpacing                       = 5;
        layout.minimumInteritemSpacing                  = 5;
        layout.sectionInset                             = UIEdgeInsetsMake(0, 10, 15, 10);
        _collectionView                                 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0) collectionViewLayout:layout];
        _collectionView.delegate                        = self;
        _collectionView.dataSource                      = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"YFItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFItemCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"YFCarTypeItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YFCarTypeItemCollectionViewCell"];
        [self.collectionView registerNib:[UINib nibWithNibName:@"YFFindCarCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFFindCarCollectionReusableView"];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}


- (IBAction)clickSaveBtn:(id)sender {
    [self disappear];
    if (self.isCarType) {
        //存储搜索历史
        [YFUserDefaults setObject:[NSArray saveCarTypeData:self.selectTypeArr] forKey:@"HistoryTypeArr"];
        [YFUserDefaults synchronize];
    }else{
        [YFUserDefaults setObject:[NSArray saveCarLengthData:self.selctLengthArr] forKey:@"HistoryLengthArr"];
        [YFUserDefaults synchronize];
    }
    !self.resetSelectTypeBlock ? : self.resetSelectTypeBlock(self.isCarType ? self.selectTypeArr : self.selctLengthArr);
}


@end
