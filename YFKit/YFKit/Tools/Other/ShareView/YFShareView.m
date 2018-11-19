//
//  YFShareView.m
//  YFKit
//
//  Created by 王宇 on 2018/5/23.
//  Copyright © 2018年 wy. All rights reserved.
//

#import "YFShareView.h"
#import "YFShareButton.h"
#import "YFUmengTracking.h"
#import "YFShareQRcodeViewController.h"

@interface YFShareView()
/**
 图片
 */
@property (nonatomic, strong, nullable) NSArray *imgArr;
/**
title
 */
@property (nonatomic, strong, nullable) NSArray *titleArr;

@property (nonatomic,weak) UIView *tipView;
@property (nonatomic,weak) UIView *cover;

@end

@implementation YFShareView

- (instancetype)initWithFrame:(CGRect)frame shareType: (YFShareContentType)shareType{
   self = [super initWithFrame:frame];
    if (self) {
        // 创建一个阴影
        UIWindow *win                           = [UIApplication sharedApplication].keyWindow;
        UIView *cover                           = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        cover.backgroundColor                   = [UIColor blackColor];
        self.cover                              = cover;
        [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCancel)]];
        cover.tag                               = 100;
        cover.alpha                             = 0;
        [win addSubview:cover];
        
        // 创建一个提示框
        CGFloat tipX                            = 0;
        CGFloat tipW                            = cover.frame.size.width - 2*tipX;
        CGFloat tipH                            = 220;
        
        UIView *tipViews                        = [[UIView alloc] initWithFrame:CGRectMake(tipX, ScreenHeight, tipW, tipH)];
        tipViews.backgroundColor                = [UIColor whiteColor];
        [win addSubview:tipViews];
        self.tipView = tipViews;
        
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat tipY                        = (ScreenHeight-tipH);
            cover.alpha                         = 0.5;
            tipViews.frame                      = CGRectMake(tipX, tipY, tipW, tipH);
        } completion:^(BOOL finished) {
            
        }];
        if (shareType == YFShareContentByAppType) {
            if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
                self.imgArr                         = @[@"wechat",@"wxFriends",@"QRcode"];
                self.titleArr                       = @[@"微信好友",@"朋友圈",@"二维码"];
            }else{
                self.imgArr                         = @[@"QRcode"];
                self.titleArr                       = @[@"二维码"];
            }
        }else{
            if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
                self.imgArr                         = @[@"wechat",@"wxFriends"];
                self.titleArr                       = @[@"微信好友",@"朋友圈"];
            }
        }
        
    
        for (int i = 0; i < self.imgArr.count; i ++) {
            __weak YFShareButton *shareBtn      = [[[NSBundle mainBundle] loadNibNamed:@"YFShareButton" owner:nil options:nil] firstObject];
            NSInteger line = self.titleArr.count;
            CGFloat btnW = 80;
            CGFloat margin = (tipViews.mj_w - line*btnW)*0.25;
            CGFloat btnX = margin + i%line*(btnW+margin);
            CGFloat btnY = i/line*btnW;
            if (shareType == YFShareContentByAppType) {
                //分享APP
                if (line == 1) {
                    shareBtn.frame              = CGRectMake((ScreenWidth-btnW)/2,60 + btnY, btnW, btnW);
                }else{
                    shareBtn.frame              = CGRectMake(btnX,60 + btnY, btnW, btnW);
                }
            }else{
                //分享货源
                if (i == 0) {
                    shareBtn.frame              = CGRectMake(ScreenWidth/4-50, 60 + btnY, btnW, btnW);
                }else{
                    shareBtn.frame              = CGRectMake(ScreenWidth/4*3-50, 60 + btnY, btnW, btnW);
                }
            }
            shareBtn.autoresizingMask           = 0;
            @weakify(self)
            shareBtn.clickShareBtnBlock         = ^{
                @strongify(self)
                [self clickShareBtn:shareBtn];
            };
            shareBtn.title.text                 = self.titleArr[i];
            shareBtn.imgView.image              = [UIImage imageNamed:self.imgArr[i]];
            [tipViews addSubview:shareBtn];
        }
        
        UIButton *cancelBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame                         = CGRectMake(ScreenWidth-50, 0, 50, 50);
        [cancelBtn setImage:[UIImage imageNamed:@"chose"] forState:0];
        [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        [tipViews addSubview:cancelBtn];
        
    }
    return self;
}

- (void)clickCancel
{
    [UIView animateWithDuration:0.2 animations:^{
        self.tipView.mj_y = ScreenHeight;
        self.cover.alpha = 0;
    } completion:^(BOOL finished) {
        [self.tipView removeFromSuperview];
        [self.cover removeFromSuperview];
        self.cover = nil;
        self.tipView = nil;
    }];
}

-(void)clickShareBtn:(YFShareButton *)btn{
    DLog(@"%@",btn.title.text);
    [self clickCancel];
    //统计分享
    [YFUmengTracking umengEvent:@"RecommendedShare"];
    
    if ([btn.title.text isEqualToString:@"微信好友"]) {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }else if([btn.title.text isEqualToString:@"朋友圈"]){
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }else{
        YFShareQRcodeViewController *share = [YFShareQRcodeViewController new];
        share.hidesBottomBarWhenPushed = YES;
        [self.superVC.navigationController pushViewController:share animated:YES];
    }
    
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UIImage *thumbURL = [UIImage imageNamed:self.shareImage] ;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareContent thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.shareUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
#ifdef UM_Swift
    [UMSocialSwiftInterface shareWithPlattype:platformType messageObject:messageObject viewController:self.superVC completion:^(UMSocialShareResponse * data, NSError * error) {
#else
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.superVC completion:^(id data, NSError *error) {
#endif
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
//                   [ YFToast showMessage:@"分享成功" inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }

        }];
    }
     
- (void)setPinterstInfo:(UMSocialMessageObject *)messageObj
{
    messageObj.moreInfo = @{@"source_url": @"http://www.umeng.com",
                            @"app_name": @"U-Share",
                            @"suggested_board_name": @"UShareProduce",
                            @"description": @"U-Share: best social bridge"};
}




@end
