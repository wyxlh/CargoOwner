//
//  YFCarSourceService.m
//  YFKit
//
//  Created by 王宇 on 2018/6/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFCarSourceService.h"
#import "YFMyMaturingCarTableViewCell.h"

@implementation YFCarSourceService

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFMyMaturingCarTableViewCell *cell          = [tableView dequeueReusableCellWithIdentifier:@"YFMyMaturingCarTableViewCell" forIndexPath:indexPath];
    if (self.viewModel.dataArr.count != 0) {
        cell.model                              = self.viewModel.dataArr[indexPath.row];
    }
    cell.addressLogo.hidden                     = YES;
    @weakify(self)
    cell.callBackBlock                          = ^(BOOL isLike){
        @strongify(self)
        if (isLike) {
            [self.viewModel likeCar:[self.viewModel.dataArr[indexPath.row] carId] DriverId:[self.viewModel.dataArr[indexPath.row] driverId]];
        }else{
            [self.viewModel cancelLikeWithCarId:[self.viewModel.dataArr[indexPath.row] carId] DriverId:[self.viewModel.dataArr[indexPath.row] carId]];
        }
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel jumpCtrlWithDriverId:[self.viewModel.dataArr[indexPath.row] driverId]];
}


@end
