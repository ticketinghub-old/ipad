//
//  TXHTicketDetailsViewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 07/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHProductsManager;
@class TXHTicketDetailsViewController;

@protocol TXHTicketDetailsViewControllerDelegate

- (void)txhTicketDetailsViewControllerShouldDismiss:(TXHTicketDetailsViewController *)controller;
- (void)txhTicketDetailsViewController:(TXHTicketDetailsViewController *)controller didChangeTicket:(TXHTicket *)ticket;
- (void)txhTicketDetailsViewController:(TXHTicketDetailsViewController *)controller wantsToPresentOrderForTicket:(TXHTicket *)ticket;

@end

@interface TXHTicketDetailsViewController : UIViewController

@property (nonatomic, weak) id<TXHTicketDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) TXHTicket *ticket;
@property (nonatomic, strong) TXHProductsManager *productManager;
@end
