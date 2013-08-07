//
//  TXHSalesCompletionViewController.h
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesCompletionViewController : UIViewController

// The current step in ticket sales processing
@property (assign, nonatomic) NSUInteger step;

// Can the current step be completed (enables / disables the continue button)
@property (assign, nonatomic) BOOL canCompleteStep;

// New vertical height of the view (used to resize  the parent container)
@property (assign, nonatomic) CGFloat newVerticalHeight;

// animationHandlerBlock - conforms to animation completion block
@property (copy) void (^animationHandler)(BOOL finished);

// This block will be called when a user indicates that they want to continue to the next step
@property (copy) void (^completionBlock)(void);

@end
