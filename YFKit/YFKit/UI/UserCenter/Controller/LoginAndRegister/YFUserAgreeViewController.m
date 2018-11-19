//
//  YFUserAgreeViewController.m
//  YFKit
//
//  Created by 王宇 on 2018/5/25.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFUserAgreeViewController.h"
#import "YFUserAgreeTableViewCell.h"
@interface YFUserAgreeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YFUserAgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title                          = @"用户协议";
    self.tableView.estimatedRowHeight   = 200;
    [self.tableView registerNib:[UINib nibWithNibName:@"YFUserAgreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"YFUserAgreeTableViewCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YFUserAgreeTableViewCell *cell      = [tableView dequeueReusableCellWithIdentifier:@"YFUserAgreeTableViewCell" forIndexPath:indexPath];
    cell.content.text                   = @"学习 GCD 之前，先来了解 GCD 中两个核心概念：任务和队列。任务：就是执行操作的意思，换句话说就是你在线程中执行的那段代码。在 GCD 中是放在 block 中的。执行任务有两种方式：同步执行（sync）和异步执行（async）。两者的主要区别是：是否等待队列的任务执行结束，以及是否具备开启新线程的能力。同步执行（sync）：同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行。能在当前线程中执行任务，特点是:不具备开启新线程的能力。 异步执行（async）：异步添加任务到指定的队列中，它不会做任何等待，可以继续执行任务。可以在新的线程中执行任务，特点是:具备开启新线程的能力。";
    return cell;
}



@end
