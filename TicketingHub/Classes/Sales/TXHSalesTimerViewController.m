//
//  TXHSalesTimerViewController.m
//  TicketingHub
//
//  Created by Mark on 02/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesTimerViewController.h"

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

- (void)setStepTitle:(NSString *)stepTitle {
    _stepTitle = stepTitle;
    self.stepDescription.text = stepTitle;
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
    
    // Determine elapsed interval since the timer started
    NSTimeInterval elapsed = -[startDate timeIntervalSinceNow];
    
    // Determine how long there is to go
    NSTimeInterval timeLeft = self.duration - elapsed;
    
    // If the timer has expired then notify whoever is concerned
    if (timeLeft < 0) {
        [[UIApplication sharedApplication] sendAction:@selector(orderExpiredWithSender:) to:nil from:self forEvent:nil];
        return;
    }
    
    // If we have < 5 seconds of the duration left turn indicator red
    if (timeLeft < 5.0f) {
        self.timerImage.tintColor = [UIColor redColor];
    } else if (timeLeft < 10.0f) {
        self.timerImage.tintColor = [UIColor orangeColor];
    } else {
        self.timerImage.tintColor = [UIColor greenColor];
    }
    
    self.timeDisplay.text = [TXHTimeFormatter stringFromTimeInterval:timeLeft];
}

@end
