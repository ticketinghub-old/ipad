//
//  TXHLoginViewController.h
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import UIKit;

#import "TXHNetworkController.h"

@interface TXHLoginViewController : UIViewController

@property (strong ,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) TXHNetworkController *networkController;

@end
