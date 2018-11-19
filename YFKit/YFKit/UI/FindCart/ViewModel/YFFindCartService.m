//
//  YFFindCartService.m
//  YFKit
//
//  Created by 王宇 on 2018/6/15.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFFindCartService.h"
#import "YFMyMaturingCarTableViewCell.h"
#import "YFFindNoCarTableViewCell.h"

@implementation YFFindCartService

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.viewModel.dataArr.count == 0) {
        return section == 0 ? 1 : self.viewModel.likeDataArr.count;
    }
    return section == 0 ? 0 : self.viewModel.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YFFindNoCarTableViewCell *cell          = [tableView dequeueReusableCellWithIdentifier:@"YFFindNoCarTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    YFMyMaturingCarTableViewCell *cell          = [tableView dequeueReusableCellWithIdentifier:@"YFMyMaturingCarTableViewCell" forIndexPath:indexPath];
    if (self.viewModel.dataArr.count != 0) {
        cell.Lmodel                             = self.viewModel.dataArr[indexPath.row];
    }else{
        cell.model                              = self.viewModel.likeDataArr[indexPath.row];
    }
    
    @weakify(self)
    cell.callBackBlock                          = ^ (BOOL isLike){
        @strongify(self)
        if (self.viewModel.dataArr.count != 0) {
            [self.viewModel cancelLikeWithCarId:[self.viewModel.dataArr[indexPath.row] carId] DriverId:[self.viewModel.dataArr[indexPath.row] driverId]];
        }else{
            [self.viewModel likeCar:[self.viewModel.likeDataArr[indexPath.row] carId] DriverId:[self.viewModel.likeDataArr[indexPath.row] driverId]];
        }
        
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.viewModel.dataArr.count == 0) {
        return indexPath.section == 0 ? 225.0f : 100.0f;
    }
    return indexPath.section == 0 ? CGFLOAT_MIN : 150.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.viewModel.dataArr.count == 0) {
        return section == 0 ? CGFLOAT_MIN : 30.0f;
    }
    return 2.5f;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.viewModel.dataArr.count == 0) {
        UIView *sectionView                          = [[UIView alloc]init];
        sectionView.backgroundColor                  = UIColorFromRGB(0xEFF4F9);
        UILabel *lbl                                 = [[UILabel alloc]initWithFrame:CGRectMake(16, 7, 100, 17)];
        lbl.text                                     = @"可能关注";
        lbl.font                                     = [UIFont systemFontOfSize:14];
        lbl.textColor                                = UIColorFromRGB(0x6C6D6E);
        [sectionView addSubview:lbl];
        return section == 1 ? sectionView : [UIView new];
    }
    return [UIView new];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.viewModel.dataArr.count != 0) {
        [self.viewModel jumpCtrlWithDriverId:[self.viewModel.dataArr[indexPath.row] driverId]];
    }else{
        if (indexPath.section == 1) {
            [self.viewModel jumpCtrlWithDriverId:[self.viewModel.likeDataArr[indexPath.row] driverId]];
        }
    }
}

@end
