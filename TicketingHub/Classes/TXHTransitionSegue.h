//
//  TXHTransitionSegue.h
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHTransitionSegue : UIStoryboardSegue

@property (weak, nonatomic) UIView *containerView;

@property (nonatomic) UIViewAnimationOptions animationOptions;

@end
