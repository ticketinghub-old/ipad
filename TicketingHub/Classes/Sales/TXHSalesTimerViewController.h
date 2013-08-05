//
//  TXHSalesTimerViewController.h
//  TicketingHub
//
//  Created by Mark on 02/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesTimerViewController : UIViewController

// The payment method segmented control
@property (weak, nonatomic) IBOutlet UISegmentedControl *paymentSelection;

// A description to display in large text on the left hand side
@property (strong, nonatomic) NSString *stepTitle;

// The length of time remaining to countdown
@property (assign, nonatomic) NSTimeInterval duration;

// New vertical height of the view (used to resize container)
@property (assign, nonatomic) CGFloat newVerticalHeight;

// animationHandlerBlock - conforms to animation completion block
@property (copy) void (^animationHandler)(BOOL finished);

// Hide or show a countdown timer
- (void)hideCountdownTimer:(BOOL)hidden;

// Hide or show a payment selection
- (void)hidePaymentSelection:(BOOL)hidden;

@end
