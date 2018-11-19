//
//  YFSpecialListService.m
//  YFKit
//
//  Created by 王宇 on 2018/9/17.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFSpecialListService.h"
#import "YFSpecialLineListTableViewCell.h"
#import "YFSpecialLineListFooterView.h"

@implementation YFSpecialListService

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFSpecialLineListTableViewCell *cell        = [tableView dequeueReusableCellWithIdentifier:@"YFSpecialLineListTableViewCell" forIndexPath:indexPath];
    cell.model                                  = self.viewModel.dataArr[indexPath.section];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YFSpecialLineListFooterView *footer         = [[[NSBundle mainBundle] loadNibNamed:@"YFSpecialLineListFooterView" owner:nil options:nil] lastObject];
    footer.shipStatue                           = self.viewModel.shipStatue;
    WS(weakSelf)
    footer.clickRightBtnBlock                   = ^(NSString *title){
        [weakSelf.viewModel handleSpecialLineOrderWithtTitle:title section:section];
    };
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 4.0f : 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 48.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel jumpCtrlWithSelectSection:indexPath.section];
}

@end
