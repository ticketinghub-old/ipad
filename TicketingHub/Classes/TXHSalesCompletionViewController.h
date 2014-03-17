//
//  TXHSalesCompletionViewController.h
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHSalesCompletionViewController;

@protocol TXHSalesCompletionViewControllerDelegate <NSObject>

- (void)salesCompletionViewControllerDidCancel:(TXHSalesCompletionViewController *)controller;
- (void)salesCompletionViewControllerDidContinue:(TXHSalesCompletionViewController *)controller;

@end

@interface TXHSalesCompletionViewController : UIViewController

@property (weak, nonatomic) id<TXHSalesCompletionViewControllerDelegate> delegate;

- (void)setContinueButtonTitle:(NSString *)continueButtonTitle;
- (void)setContinueButtonEnabled:(BOOL)enabled;
- (void)setCancelButtonHidden:(BOOL)hidden;

@end
