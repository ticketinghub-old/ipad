//
//  TXHMenuViewController.h
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  This is the root view controller for the entire app

#import <UIKit/UIKit.h>
#import "TXHVenueSelectionProtocol.h"

@interface TXHMenuViewController : UIViewController <TXHVenueSelectionProtocol>

- (void)presentLoginViewController;

@end
