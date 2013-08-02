//
//  TXHSalesTimerViewController.m
//  TicketingHub
//
//  Created by Mark on 02/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTimerViewController.h"

#import "TXHTimeFormatter.h"

@interface TXHSalesTimerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *stepDescription;
@property (weak, nonatomic) IBOutlet UIImageView *timerImage;
@property (weak, nonatomic) IBOutlet UILabel *timeDisplay;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDictionary *userInfo;

@end

@implementation TXHSalesTimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [self removeTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the image to be a template image
    self.timerImage.image = [[UIImage imageNamed:@"EmptyCircle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.timerImage.tintColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self removeTimer];
}

- (NSDictionary *)userInfo {
    return @{ @"StartDate" : [NSDate date]};
}

- (void)hideCountdownTimer:(BOOL)hidden {
    self.timerImage.hidden = hidden;
    self.timeDisplay.hidden = hidden;
    
    if (hidden) {
        [self removeTimer];
    } else {
        [self createTimer];
    }
}

- (void)createTimer {
    // Stop any previous timer that may have been active
    [self.timer invalidate];
    
    // If the duration is <= 0.0 there is no countdown left
    if (self.duration <= 0.0f) {
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.50f
                                                  target:self
                                                selector:@selector(timerFireMethod:)
                                                userInfo:[self userInfo]
                                                 repeats:YES];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerFireMethod:(NSTimer *)theTimer {
    NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
    NSLog(@"Timer started on %@", startDate);
    
    // Determine elapsed interval since the timer started
    NSTimeInterval elapsed = [startDate timeIntervalSinceNow];
    
    // Determine how long there is to go
    NSTimeInterval timeLeft = self.duration - elapsed;
    
    // If the timer has expired then hide it
    if (timeLeft < 0) {
        [self hideCountdownTimer:YES];
        return;
    }
    
    double percentageRemaining = (100.0f * timeLeft) / self.duration;
    
    // If we have < 10% of the duration left turn indicator red
    if (percentageRemaining < 10.0f) {
        self.timerImage.tintColor = [UIColor redColor];
    } else if (percentageRemaining < 50.0f) {
        self.timerImage.tintColor = [UIColor orangeColor];
    } else {
        self.timerImage.tintColor = [UIColor greenColor];
    }
    
    self.timeDisplay.text = [TXHTimeFormatter stringFromTimeInterval:timeLeft];
}

@end
