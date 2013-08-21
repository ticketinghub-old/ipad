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
@property (weak, nonatomic) IBOutlet UIView *dividingLine;
@property (weak, nonatomic) IBOutlet UIView *couponView;

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
    self.dividingLine.backgroundColor = [UIColor colorWithRed:200.0f /255.0f
                                                        green:200.0f / 255.0f
                                                         blue:200.0f / 255.0f
                                                        alpha:1.0f];
    
    // Set the initial height for the view
    self.newVerticalHeight = 102.0f;

    // Initially the timer and payment selection are hidden
    [self resetPresentationAnimated:NO];
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
    
    // If we are showing the timer, create one if needed
    if (hidden == NO) {
        if (self.timer == nil) {
            [self createTimer];
        }
    }
}

- (void)stopCountdownTimer {
    [self removeTimer];
    [self hideCountdownTimer:YES];
}


- (void)resetPresentationAnimated:(BOOL)animated {
    [self hideCountdownTimer:YES];
    [self hidePaymentSelection:YES animated:animated];
    [self hideCoupon:YES animated:animated];
}

- (void)hideCoupon:(BOOL)hidden animated:(BOOL)animated {
    __block typeof(self) blockSelf = self;
    
    self.newVerticalHeight = hidden ? 84.0f : 136.0f;
    
    if (animated) {
        self.animationHandler = ^(BOOL finished) {
#pragma unused (finished)
            blockSelf.couponView.hidden = hidden;
        };
    } else {
        self.animationHandler = nil;
        self.couponView.hidden = hidden;
    }
    
    [[UIApplication sharedApplication] sendAction:@selector(updateTimerContainerHeight:) to:nil from:self forEvent:nil];
}

- (void)hidePaymentSelection:(BOOL)hidden animated:(BOOL)animated {
    __block typeof(self) blockSelf = self;
    
    self.newVerticalHeight = hidden ? 84.0f : 136.0f;

    if (animated) {
        self.animationHandler = ^(BOOL finished) {
#pragma unused (finished)
            blockSelf.paymentSelection.hidden = hidden;
        };
    } else {
        self.animationHandler = nil;
        self.paymentSelection.hidden = hidden;
    }
    
    [[UIApplication sharedApplication] sendAction:@selector(updateTimerContainerHeight:) to:nil from:self forEvent:nil];
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
    
    UIColor *tintColor;
    // If we have < 5 seconds of the duration left turn indicator red
    if (timeLeft < 5.0f) {
        tintColor = [UIColor redColor];
    } else if (timeLeft < 10.0f) {
        // Calculate a tint colour going from orange to red
        CGFloat factor = timeLeft / 10.0f;
        CGFloat redComponent = 1.0f;
        CGFloat greenComponent = 0.50f * factor;
        tintColor = [UIColor colorWithRed:redComponent green:greenComponent blue:0.0f alpha:1.0f];
    } else {
        // Calculate a tint colour going from green to orange
        CGFloat factor = (MAX(0.0f, (timeLeft - 10.0f)) / (self.duration - 10.0f));
        CGFloat redComponent = (1.0f - factor);
        CGFloat greenComponent = (1.0f - (0.50f * (1 - factor)));
        tintColor = [UIColor colorWithRed:redComponent green:greenComponent blue:0.0f alpha:1.0f];
    }
    
    self.timerImage.tintColor = tintColor;
    if (timeLeft < 10.0f) {
        self.timeDisplay.textColor = tintColor;
    }
    self.timeDisplay.text = [TXHTimeFormatter stringFromTimeInterval:timeLeft];
}


- (IBAction)paymentMethodChanged:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(didChangePaymentMethod:) to:nil from:self.paymentSelection forEvent:nil];
}

@end
