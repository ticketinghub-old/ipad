//
//  UIView+TXHAnimationConversions.h
//  TicketingHub
//
//  Created by Mark on 19/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TXHAnimationConversions)

+ (UIViewAnimationOptions)txhAnimationOptionsFromAnimationCurve:(UIViewAnimationCurve)curve;

@end
