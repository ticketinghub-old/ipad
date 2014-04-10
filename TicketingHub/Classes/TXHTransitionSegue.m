//
//  TXHTransitionSegue.m
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTransitionSegue.h"

@implementation TXHTransitionSegue

- (void)perform
{
  UIViewController *sourceViewController = self.sourceViewController;
  
  UIViewController *viewControllerToReplace = sourceViewController.childViewControllers.lastObject;
  
  if (!viewControllerToReplace)
  {
    return;
  }
  
  
  [viewControllerToReplace willMoveToParentViewController:nil];
  
  
  UIViewController *destinationViewController = self.destinationViewController;
  
  [sourceViewController addChildViewController:destinationViewController];


  destinationViewController.view.frame = self.containerView.bounds;
  
  [sourceViewController transitionFromViewController:viewControllerToReplace
                                    toViewController:destinationViewController
                                            duration:0.5
                                             options:UIViewAnimationOptionTransitionCrossDissolve
                                          animations:nil
                                          completion:^(BOOL finished)
   {
#pragma unused (finished)
     [viewControllerToReplace removeFromParentViewController];
     
     [destinationViewController didMoveToParentViewController:sourceViewController];
   }];
}

@end
