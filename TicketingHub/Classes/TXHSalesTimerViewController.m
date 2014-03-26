//
//  TXHSalesTimerViewController.m
//  TicketingHub
//
//  Created by Mark on 02/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTimerViewController.h"

#import "TXHSalesTimerViewController.h"
#import "UIColor+TicketingHub.h"

#import "RMDownloadIndicator.h"

@interface TXHSalesTimerViewController ()

@property (strong, nonatomic) RMDownloadIndicator *timerIndicator;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timerLabel;

@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSDate *starDate;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation TXHSalesTimerViewController

- (void)setTitleText:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setTimerEndDate:(NSDate *)date
{
    if (!date){
        [self removeTimer];
        self.endDate = nil;
    }
    else if (!self.endDate)
    {
        self.endDate = date;
        [self addTimer];
    }
        
}

- (void)removeTimer
{
    [self.timerIndicator removeFromSuperview];
    [self.timerLabel removeFromSuperview];
    [self stopTimer];
}

- (void)stopTimer
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)addTimer
{
    self.starDate = [NSDate date];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;

    [self addTimerLabel];
    [self addTimerIndicator];
    
    [self timerFireMethod:timer];
}

- (void)addTimerIndicator
{
    RMDownloadIndicator *timerIndicator = [[RMDownloadIndicator alloc]initWithFrame:CGRectMake(0, 0, 30, 30) type:kRMMixedIndictor];
    timerIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    timerIndicator.center = CGPointMake(0 , self.view.height / 2.0);
    timerIndicator.right = self.timerLabel.left - 10;
    
    [timerIndicator setBackgroundColor:self.view.backgroundColor];
    [timerIndicator setFillColor:[UIColor txhDarkBlueColor]];
    [timerIndicator setStrokeColor:[UIColor txhDarkBlueColor]];
    [timerIndicator setRadiusPercent:0.45];
    [self.view addSubview:timerIndicator];
    [timerIndicator loadIndicator];
    
    self.timerIndicator = timerIndicator;
}

- (void)addTimerLabel
{
    UILabel *timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    timerLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    timerLabel.center = CGPointMake(0, self.view.height / 2.0);
    timerLabel.right = self.view.width - 10;
    
    timerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
    timerLabel.textColor = [UIColor txhDarkBlueColor];

    [self.view addSubview:timerLabel];
    self.timerLabel = timerLabel;
}

- (void)timerFireMethod:(NSTimer *)tiemr
{
    NSTimeInterval total = [self.endDate timeIntervalSince1970] - [self.starDate timeIntervalSince1970];
    NSTimeInterval current = [self.endDate timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970];
    
    if (current < 0)
    {
        [self stopTimer];
        current = 0;
    }
    
    NSInteger minutes = floor((current/60));
    NSInteger seconds = floor(current - (minutes * 60));
    
    self.timerLabel.text = [NSString stringWithFormat:@"%ld:%.2ld",(long)minutes,(long)seconds];
    
    [self.timerIndicator updateWithTotalBytes:total downloadedBytes:current];
}

@end
