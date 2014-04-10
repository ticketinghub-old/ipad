//
//  TXHEmbeddingSegue.m
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHEmbeddingSegue.h"

@implementation TXHEmbeddingSegue

- (void)perform
{
    // convert source and destination controllers from ids
    UIViewController *sourceViewController      = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    UIViewController *previousViewController    = self.previousController;
    
    UIView *containerView = self.containerView ? self.containerView : sourceViewController.view;
    
    // set destinations controller view to fill container view all the time
    destinationViewController.view.frame = containerView.bounds;
    destinationViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    destinationViewController.view.translatesAutoresizingMaskIntoConstraints = YES;
    
    if (!previousViewController)
    {
        [sourceViewController addChildViewController:destinationViewController];
        [containerView addSubview:destinationViewController.view];
        [destinationViewController didMoveToParentViewController:sourceViewController];
    }
    else
    {
        [sourceViewController addChildViewController:destinationViewController];
        [previousViewController willMoveToParentViewController:nil];
        
        [sourceViewController transitionFromViewController:previousViewController
                                          toViewController:destinationViewController
                                                  duration:0.0
                                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                                animations:nil
                                                completion:^(BOOL finished)
         {
             [previousViewController removeFromParentViewController];
             [destinationViewController didMoveToParentViewController:sourceViewController];
        }];
    }
}

@end
