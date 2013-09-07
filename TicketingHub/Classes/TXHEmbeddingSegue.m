//
//  TXHEmbeddingSegue.m
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHEmbeddingSegue.h"

@implementation TXHEmbeddingSegue

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    return [self initWithIdentifier:identifier container:nil source:source destination:destination];
}

- (id)initWithIdentifier:(NSString *)identifier container:(UIView *)container source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    
    if (self)
    {
        _containerView = container;
    }
    
    return self;
}

- (void)perform
{
    // convert source and destination controllers from ids
    UIViewController *sourceViewController = self.sourceViewController;
    
    UIViewController *destinationViewController = self.destinationViewController;
    
    // set frame of destination controller's view to that of placeholder
    destinationViewController.view.frame = self.containerView.bounds;

    
    [sourceViewController addChildViewController:destinationViewController];
    
    [self.containerView addSubview:destinationViewController.view];
    
    [destinationViewController didMoveToParentViewController:sourceViewController];
}

@end
