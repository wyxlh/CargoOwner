//
//  YFSpecialLineService.m
//  YFKit
//
//  Created by 王宇 on 2018/9/10.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialLineService.h"
#import "YFReleaseItemTableViewCell.h"
#import "YFPlaceOrderItemTableViewCell.h"
#import "YFSpecialLineGoodsTableViewCell.h"
#import "YFGoodsHeadTableViewCell.h"
#import "YFHomeDataModel.h"

@implementation YFSpecialLineService

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel.dataArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //地址
        YFPlaceOrderItemTableViewCell *cell         = [tableView dequeueReusableCellWithIdentifier:@"YFPlaceOrderItemTableViewCell" forIndexPath:indexPath];
        cell.model                                  = self.viewModel.dataArr[indexPath.section][indexPath.row];
        return cell;
    }else if (indexPath.section == 1){
        //填写货品信息
        if (indexPath.row == 0) {
            YFGoodsHeadTableViewCell *cell          = [tableView dequeueReusableCellWithIdentifier:@"YFGoodsHeadTableViewCell" forIndexPath:indexPath];
            cell.addBtn.hidden                      = [self.viewModel.dataArr[indexPath.section] count] == 11 ? YES : NO;
            cell.model                              = self.viewModel.dataArr[indexPath.section][indexPath.row];
            @weakify(self)
            [[[cell.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self)
                [self.viewModel addGoodsInformationWithSection:indexPath.section selectIndex:indexPath.row];
            }];
            return cell;
        }
        YFSpecialLineGoodsTableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"YFSpecialLineGoodsTableViewCell" forIndexPath:indexPath];
        cell.numLbl.text                            = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        cell.deleteBtn.hidden                       = [self.viewModel.dataArr[indexPath.section] count] == 2 ? YES : NO;
        cell.model                                  = self.viewModel.dataArr[indexPath.section][indexPath.row];
        @weakify(self)
        cell.editRefreshBlock                       = ^{
            @strongify(self)
            [self.viewModel calculatedTotalFree];
        };
        //删除
        [[[cell.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel deleteGoodsInformationWithSection:indexPath.section selectIndex:indexPath.row];
        }];
        //选择货品名称
        [[[cell.goodsNameBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel chooseGoodsNameWithSection:indexPath.section selectIndex:indexPath.row];
        }];
        
        return cell;
    }
    //其他
    YFReleaseItemTableViewCell *cell                = [tableView dequeueReusableCellWithIdentifier:@"YFReleaseItemTableViewCell" forIndexPath:indexPath];
    cell.model                                      = self.viewModel.dataArr[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        //货品信息
        if (indexPath.row == 0) {
            return 48.0f;
        }
        return 185.0f;
    }else if (indexPath.section == 0){
        //地址
        return 60.0f;
    }
    //其他
    return 48.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section < 2 ? 5.0f : 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel jumpCtrlWithSelectSection:indexPath.section SelectIndex:indexPath.row];
}

@end
