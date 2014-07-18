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

- (void)txhPrintButtonsViewControllerMarkAttendingButtonAction:(TXHBorderedButton *)button;
- (void)txhPrintButtonsViewControllerPrintReciptAction:(TXHBorderedButton *)button;
- (void)txhPrintButtonsViewControllerPrintTicketsAction:(TXHBorderedButton *)button;

@end

@interface TXHPrintButtonsViewController : UIViewController


@property (weak, nonatomic) TXHOrder *order;

@property (weak, nonatomic) id<TXHPrintButtonsViewControllerDelegate> delegate;

@end
