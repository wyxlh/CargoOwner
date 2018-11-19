//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"
#import "YFCustomItemCalloutView.h"

#define kWidth  30.f
#define kHeight 30.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0

@interface CustomAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation CustomAnnotationView

@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;

#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    DLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
    !self.drawLineBlock ? : self.drawLineBlock (coorinate.latitude,coorinate.longitude);
}

#pragma mark - Override

- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            CGSize titleSize = [NSString getStringSize:16 withString:self.title andWidth:999];
            CGSize detailSize = [NSString getStringSize:16 withString:self.detail andWidth:999];
            CGFloat callViewWidth = titleSize.width - detailSize.width >= 0 ? titleSize.width + 60 : detailSize.width + 60;
            
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, callViewWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
            YFCustomItemCalloutView *itemView = [[[NSBundle mainBundle] loadNibNamed:@"YFCustomItemCalloutView" owner:nil options:nil] lastObject];
            itemView.frame                    = self.calloutView.bounds;
            itemView.height                   = self.calloutView.height-10;
            itemView.title.text               = self.title;
            itemView.detail.text              = self.detail;
            UITapGestureRecognizer *tap       = [[UITapGestureRecognizer alloc]init];
            [itemView addGestureRecognizer:tap];
            @weakify(self)
            [[tap rac_gestureSignal] subscribeNext:^(id x) {
                @strongify(self)
                [self btnAction];
            }];
            [self.calloutView addSubview:itemView];
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        
        self.backgroundColor = [UIColor clearColor];
        
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.portraitImageView];
        
//        /* Create name label. */
//        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitWidth + kHoriMargin,
//                                                                   kVertMargin,
//                                                                   kWidth - kPortraitWidth - kHoriMargin,
//                                                                   kHeight - 2 * kVertMargin)];
//        self.nameLabel.backgroundColor  = [UIColor clearColor];
//        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
//        self.nameLabel.textColor        = [UIColor whiteColor];
//        self.nameLabel.font             = [UIFont systemFontOfSize:15.f];
        [self addSubview:self.nameLabel];
    }
    
    return self;
}

@end
