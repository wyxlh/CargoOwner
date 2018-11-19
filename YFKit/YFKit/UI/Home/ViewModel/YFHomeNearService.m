//
//  YFHomeNearService.m
//  YFKit
//
//  Created by 王宇 on 2018/6/14.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFHomeNearService.h"
#import "YFHomeNearTableViewCell.h"
@implementation YFHomeNearService

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFHomeNearTableViewCell *cell               = [tableView dequeueReusableCellWithIdentifier:@"YFHomeNearTableViewCell" forIndexPath:indexPath];
    cell.title.text                             = self.viewModel.dataArr[indexPath.row];
    return cell;
}


@end
