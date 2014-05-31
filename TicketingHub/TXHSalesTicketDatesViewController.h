//
//  TXHSalesTicketDatesViewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHOrderManager;
@class TXHProductsManager;

@interface TXHSalesTicketDatesViewController : UIViewController

@property (readonly, nonatomic, getter = isValid) BOOL valid;
@property (readonly, nonatomic) BOOL shouldBeSkiped;

@property (strong, nonatomic) TXHProductsManager *productManager;
@property (strong, nonatomic) TXHOrderManager    *orderManager;

@end
