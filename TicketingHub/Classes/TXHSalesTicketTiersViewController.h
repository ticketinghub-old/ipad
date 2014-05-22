//
//  TXHSalesTicketTiersViewController.h
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHOrderManager;
@class TXHProductsManager;

@interface TXHSalesTicketTiersViewController : UIViewController

@property (readonly, readonly, getter = isValid) BOOL valid;

@property (strong, nonatomic) TXHProductsManager *productManager;
@property (strong, nonatomic) TXHOrderManager    *orderManager;

@end
