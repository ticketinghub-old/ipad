//
//  TXHDoorOrderTicketsListViewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHProductsManager;

@interface TXHDoorOrderTicketsListViewController : UITableViewController

@property (nonatomic, strong) TXHOrder *order;
@property (nonatomic, strong) TXHProductsManager *productManager;

@end
