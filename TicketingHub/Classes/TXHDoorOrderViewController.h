//
//  TXHDoorOrderViewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHProductsManager;

@interface TXHDoorOrderViewController : UIViewController

- (void)setTicket:(TXHTicket *)ticket andProductManager:(TXHProductsManager *)productManager;

@end
