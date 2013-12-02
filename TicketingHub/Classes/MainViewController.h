//
//  MainViewController.h
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  This is the root view controller for the entire app

@import UIKit;

@interface MainViewController : UIViewController

/** Show the login view controller
 
 This method makes no changes to the managed object context, so reset it manually if required.
 
 @param animated A boolean that sets whether the view controller is animated.
 @param completion a block that is run on completion. This block takes no parameters and has no return.s
 */
- (void)presentLoginViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completion;

@end
