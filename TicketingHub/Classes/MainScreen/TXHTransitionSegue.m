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
  
  
  // uses nominated animation options
  //  destinationViewController.view.frame = self.containerView.bounds;
  //
  //  [sourceViewController transitionFromViewController:viewControllerToReplace
  //                                    toViewController:destinationViewController
  //                                            duration:0.5
  //                                             options:self.animationOptions
  //                                          animations:nil
  //                                          completion:^(BOOL finished)
  //                                                      {
  //                                                        [viewControllerToReplace removeFromParentViewController];
  //
  //                                                        [destinationViewController didMoveToParentViewController:sourceViewController];
  //                                                      }];
  
  // slides views in from the left
  //  __block CGRect animationFrame = self.containerView.bounds;
  //
  //  animationFrame.origin.x = -animationFrame.size.width;
  //
  //  destinationViewController.view.frame = animationFrame;
  //
  //  [sourceViewController transitionFromViewController:viewControllerToReplace
  //                                    toViewController:destinationViewController
  //                                            duration:0.5
  //                                             options:UIViewAnimationOptionTransitionNone
  //                                          animations:^
  //                                                      {
  //                                                        animationFrame.origin.x = 0;
  //
  //                                                        destinationViewController.view.frame = animationFrame;
  //
  //                                                        animationFrame.origin.x = animationFrame.size.width;
  //
  //                                                        viewControllerToReplace.view.frame = animationFrame;
  //                                                      }
  //                                          completion:^(BOOL finished)
  //                                                      {
  //                                                        [viewControllerToReplace removeFromParentViewController];
  //
  //                                                        [destinationViewController didMoveToParentViewController:sourceViewController];
  //                                                      }];
  //
  // automatically cross-fades views
  destinationViewController.view.frame = self.containerView.bounds;
  
  [sourceViewController transitionFromViewController:viewControllerToReplace
                                    toViewController:destinationViewController
                                            duration:0.5
                                             options:UIViewAnimationOptionTransitionCrossDissolve
                                          animations:nil
                                          completion:^(BOOL finished)
   {
     [viewControllerToReplace removeFromParentViewController];
     
     [destinationViewController didMoveToParentViewController:sourceViewController];
   }];
  
  // manually cross-fades views
  //  destinationViewController.view.frame = self.containerView.bounds;
  //
  //  destinationViewController.view.alpha = 0.0;
  //
  //  [sourceViewController transitionFromViewController:viewControllerToReplace
  //                                    toViewController:destinationViewController
  //                                            duration:0.5
  //                                             options:UIViewAnimationOptionTransitionNone
  //                                          animations:^
  //                                                      {
  //                                                        destinationViewController.view.alpha = 1.0;
  //
  //                                                        viewControllerToReplace.view.alpha = 0.0;
  //                                                      }
  //                                          completion:^(BOOL finished)
  //                                                      {
  //                                                        [viewControllerToReplace removeFromParentViewController];
  //
  //                                                        [destinationViewController didMoveToParentViewController:sourceViewController];
  //                                                      }];
}

@end
