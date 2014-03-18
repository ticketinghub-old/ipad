//
//  TXHPrintButtonsViewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHBorderedButton;
@class TXHPrintButtonsViewController;

@protocol TXHPrintButtonsViewControllerDelegate <NSObject>

- (void)txhPrintButtonsViewControllerCustomButtonAction:(TXHBorderedButton *)button;
- (void)txhPrintButtonsViewControllerPrintReciptAction:(TXHBorderedButton *)button;
- (void)txhPrintButtonsViewControllerPrintTicketsAction:(TXHBorderedButton *)button;

@end

@interface TXHPrintButtonsViewController : UIViewController

@property (weak, nonatomic) IBOutlet TXHBorderedButton *printTicketsButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *printReciptButton;
@property (weak, nonatomic) IBOutlet TXHBorderedButton *customActionButton;

@property (weak, nonatomic) id<TXHPrintButtonsViewControllerDelegate> delegate;

@end
