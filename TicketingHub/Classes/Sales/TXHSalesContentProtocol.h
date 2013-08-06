//
//  TXHSalesContentProtocol.h
//  TicketingHub
//
//  Created by Mark on 06/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TXHSalesTimerViewController.h"

//@class TXHSalesTimerViewController;
@class TXHSalesCompletionViewController;

@protocol TXHSalesContentProtocol <NSObject>

- (TXHSalesTimerViewController *)timerViewController;
- (void)setTimerViewController:(TXHSalesTimerViewController *)timerViewController;

- (TXHSalesCompletionViewController *)completionViewController;
- (void)setCompletionViewController:(TXHSalesCompletionViewController *)completionViewController;

@optional

- (void)transition:(id)sender;

@end
