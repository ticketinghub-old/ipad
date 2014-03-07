//
//  TXHTicketDetailsViewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 07/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHTicketDetailsViewController;

@protocol TXHTicketDetailsViewControllerDelegate

- (void)txhTicketDetailsViewControllerShouldDismiss:(TXHTicketDetailsViewController *)controller;

@end

@interface TXHTicketDetailsViewController : UIViewController

@property (nonatomic, weak) id<TXHTicketDetailsViewControllerDelegate> delegate;

@end
