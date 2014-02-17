//
//  TXHSalesTimerViewController.h
//  TicketingHub
//
//  Created by Mark on 02/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesTimerViewController : UIViewController

// A description to display in large text on the left hand side
@property (strong, nonatomic) NSString *stepTitle;

// The length of time remaining to countdown
@property (assign, nonatomic) NSTimeInterval duration;

// Hide or show a countdown timer
- (void)hideCountdownTimer:(BOOL)hidden;

// Stop and also hide the countdown timer
- (void)stopCountdownTimer;

@end
