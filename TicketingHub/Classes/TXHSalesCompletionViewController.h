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
- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectMiddleButton:(TXHBorderedButton *)button;
- (void)salesCompletionViewController:(TXHSalesCompletionViewController *)controller didDidSelectLeftButton:(TXHBorderedButton *)button;

@end

@interface TXHSalesCompletionViewController : UIViewController

@property (weak, nonatomic) id<TXHSalesCompletionViewControllerDelegate> delegate;

- (void)setRightButtonImage:(UIImage *)rightButtonImage;
- (void)setMiddleButtonImage:(UIImage *)middleButtonImage;

- (void)setLeftButtonTitle:(NSString *)continueButtonTitle;
- (void)setMiddleButtonTitle:(NSString *)continueButtonTitle;
- (void)setRightButtonTitle:(NSString *)continueButtonTitle;

- (void)setLeftButtonDisabled:(BOOL)disabled;
- (void)setMiddleButtonDisabled:(BOOL)disabled;
- (void)setRightButtonDisabled:(BOOL)disabled;

- (void)setLeftButtonHidden:(BOOL)hidden;
- (void)setMiddleButtonHidden:(BOOL)hidden;
- (void)setRightButtonHidden:(BOOL)hidden;

- (void)setLeftBarButtonColor:(UIColor *)color;

@end
