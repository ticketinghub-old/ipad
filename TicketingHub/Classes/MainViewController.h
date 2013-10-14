//
//  MainViewController.h
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  This is the root view controller for the entire app

#import <UIKit/UIKit.h>
#import "VenueSelectionProtocol.h"

@interface MainViewController : UIViewController <VenueSelectionProtocol>

- (void)presentLoginViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completion;

@end
