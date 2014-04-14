//
//  SalesOrDoormanViewController.h
//  TicketingHub
//
//  Created by Mark Brindle on 07/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import UIKit;

@class TXHProductsManager;

@interface TXHSalesmanDoormanContainerViewController : UIViewController

@property (strong, nonatomic) TXHProductsManager *productManager;

- (IBAction)selectMode:(id)sender;

@end
