//
//  TXHSalesCompletionViewController.h
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHBorderedButton;
@class TXHSalesCompletionViewController;

@protocol TXHSalesCompletionViewControllerDelegate <NSObject>

- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectRightButton:(TXHBorderedButton *)button;
- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectMiddleLeftButton:(TXHBorderedButton *)button;
- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectMiddleButton:(TXHBorderedButton *)button;
- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectMiddleRightButton:(TXHBorderedButton *)button;
- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectLeftButton:(TXHBorderedButton *)button;

@end

@interface TXHSalesCompletionViewController : UIViewController

@property (weak, nonatomic) id<TXHSalesCompletionViewControllerDelegate> delegate;

- (void)setLeftButtonTitle:(NSString *)buttonTitle;
- (void)setMiddleLeftButtonTitle:(NSString *)buttonTitle;
- (void)setMiddleButtonTitle:(NSString *)buttonTitle;
- (void)setMiddleRightButtonTitle:(NSString *)buttonTitle;
- (void)setRightButtonTitle:(NSString *)buttonTitle;

- (void)setButtonsDisabled:(BOOL)disabled;
- (void)setLeftButtonDisabled:(BOOL)disabled;
- (void)setMiddleLeftButtonDisabled:(BOOL)disabled;
- (void)setMiddleButtonDisabled:(BOOL)disabled;
- (void)setMiddleRightButtonDisabled:(BOOL)disabled;
- (void)setRightButtonDisabled:(BOOL)disabled;

- (void)setLeftButtonHidden:(BOOL)hidden;
- (void)setMiddleLeftButtonHidden:(BOOL)hidden;
- (void)setMiddleButtonHidden:(BOOL)hidden;
- (void)setMiddleRightButtonHidden:(BOOL)hidden;
- (void)setRightButtonHidden:(BOOL)hidden;


@end
