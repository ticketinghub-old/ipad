//
//  TXHPrintButtonsViewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHBorderedButton;
@class TXHOrderFooterViewController;

@protocol TXHOrderFooterViewControllerDelegate <NSObject>

- (void)txhPrintButtonsViewControllerMarkAttendingButtonAction:(TXHBorderedButton *)button;

@end

@interface TXHOrderFooterViewController : UIViewController


@property (weak, nonatomic) TXHOrder *order;

@property (weak, nonatomic) id<TXHOrderFooterViewControllerDelegate> delegate;

@end
