//
//  TXHDoorTicketsListViewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 05/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHProductsManager;

@interface TXHDoorTicketsListViewController : UITableViewController

@property (strong, nonatomic) TXHProductsManager *productManager;

@end
