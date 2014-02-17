//
//  TXHSalesCompletionViewController.h
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesCompletionViewController : UIViewController

// Can the current step be completed (enables / disables the continue button)
@property (assign, nonatomic) BOOL canCompleteStep;

@end
