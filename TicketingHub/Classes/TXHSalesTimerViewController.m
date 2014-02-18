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

@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
//@property (weak, nonatomic) IBOutlet UILabel     *timeDisplay;
//@property (weak, nonatomic) IBOutlet UIImageView *timerImage;

//@property (strong, nonatomic) NSTimer      *timer;
//@property (strong, nonatomic) NSDictionary *userInfo;

@end

@implementation TXHSalesTimerViewController

//- (void)dealloc {
//    [self removeTimer];
//}

- (void)setTitleText:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the image to be a template image
//    self.timerImage.image = [[UIImage imageNamed:@"EmptyCircle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    self.timerImage.tintColor = [UIColor greenColor];

    // Initially the timer and payment selection are hidden
//    [self resetPresentationAnimated:NO];
}

// TODO: hmmm...
//- (NSDictionary *)userInfo {
//    return @{ @"StartDate" : [NSDate date]};
//}

//- (void)setStepTitle:(NSString *)stepTitle {
//    _stepTitle = stepTitle;
//    self.stepDescription.text = stepTitle;
//}
//
//- (void)hideCountdownTimer:(BOOL)hidden {
//    self.timerImage.hidden = hidden;
//    self.timeDisplay.hidden = hidden;
//    
//    // If we are showing the timer, create one if needed
//    if (hidden == NO) {
//        if (self.timer == nil) {
//            [self createTimer];
//        }
//    }
//}

//- (void)stopCountdownTimer {
//    [self removeTimer];
//    [self hideCountdownTimer:YES];
//}

//- (void)createTimer {
//    // Stop any previous timer that may have been active
//    [self.timer invalidate];
//    
//    // If the duration is <= 0.0 there is no countdown left
//    if (self.duration <= 0.0f) {
//        return;
//    }
//    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.50f
//                                                  target:self
//                                                selector:@selector(timerFireMethod:)
//                                                userInfo:[self userInfo]
//                                                 repeats:YES];
//}

//- (void)removeTimer {
//    [self.timer invalidate];
//    self.timer = nil;
//}

//- (void)timerFireMethod:(NSTimer *)theTimer {
//    NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
//    
//    // Determine elapsed interval since the timer started
//    NSTimeInterval elapsed = -[startDate timeIntervalSinceNow];
//    
//    // Determine how long there is to go
//    NSTimeInterval timeLeft = self.duration - elapsed;
//
//    // If the timer has expired then notify whoever is concerned
//    if (timeLeft < 0) {
//        [[UIApplication sharedApplication] sendAction:@selector(orderExpiredWithSender:) to:nil from:self forEvent:nil];
//        return;
//    }
//    
//    UIColor *tintColor;
//    // If we have < 5 seconds of the duration left turn indicator red
//    if (timeLeft < 5.0f) {
//        tintColor = [UIColor redColor];
//    } else if (timeLeft < 10.0f) {
//        // Calculate a tint colour going from orange to red
//        CGFloat factor = timeLeft / 10.0f;
//        CGFloat redComponent = 1.0f;
//        CGFloat greenComponent = 0.50f * factor;
//        tintColor = [UIColor colorWithRed:redComponent green:greenComponent blue:0.0f alpha:1.0f];
//    } else {
//        // Calculate a tint colour going from green to orange
//        CGFloat factor = (MAX(0.0f, (timeLeft - 10.0f)) / (self.duration - 10.0f));
//        CGFloat redComponent = (1.0f - factor);
//        CGFloat greenComponent = (1.0f - (0.50f * (1 - factor)));
//        tintColor = [UIColor colorWithRed:redComponent green:greenComponent blue:0.0f alpha:1.0f];
//    }
//    
//    self.timerImage.tintColor = tintColor;
//    if (timeLeft < 10.0f) {
//        self.timeDisplay.textColor = tintColor;
//    }
//    self.timeDisplay.text = [TXHTimeFormatter stringFromTimeInterval:timeLeft];
//}


@end
