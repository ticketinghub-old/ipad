//
//  TXHSalesCompletionViewController.h
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesCompletionViewController : UIViewController

// New vertical height of the view (used to resize container)
@property (assign, nonatomic) CGFloat newVerticalHeight;

// animationHandlerBlock - conforms to animation completion block
@property (copy) void (^animationHandler)(BOOL finished);

@end
