//
//  TXHEmbeddingSegue.h
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHEmbeddingSegue : UIStoryboardSegue

@property (weak, nonatomic) UIView *containerView;

- (id)initWithIdentifier:(NSString *)identifier container:(UIView *)container source:(UIViewController *)source destination:(UIViewController *)destination;

@end
