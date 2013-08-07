//
//  TXHSalesContentProtocol.h
//  TicketingHub
//
//  Created by Mark on 06/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TXHSalesTimerViewController.h"
#import "TXHSalesCompletionViewController.h"

@protocol TXHSalesContentProtocol <NSObject>

- (TXHSalesTimerViewController *)timerViewController;
- (void)setTimerViewController:(TXHSalesTimerViewController *)timerViewController;

- (TXHSalesCompletionViewController *)completionViewController;
- (void)setCompletionViewController:(TXHSalesCompletionViewController *)completionViewController;

// When a user elects to continue from a step in the wizard, this completion block will perform appropriate processing for that step
- (void (^)(void))completionBlock;
- (void)setCompletionBlock:(void (^)(void))completionBlock;

@optional

- (void)transition:(id)sender;

@end
