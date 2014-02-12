//
//  SalesOrDoormanViewController.h
//  TicketingHub
//
//  Created by Mark Brindle on 07/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import UIKit;

@class TXHProduct;

@interface SalesOrDoormanViewController : UIViewController

@property (strong, nonatomic) TXHProduct *selectedProduct;

- (IBAction)selectMode:(id)sender;

@end
