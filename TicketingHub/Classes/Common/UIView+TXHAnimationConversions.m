//
//  UIView+TXHAnimationConversions.m
//  TicketingHub
//
//  Created by Mark on 19/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "UIView+TXHAnimationConversions.h"

@implementation UIView (TXHAnimationConversions)

+ (UIViewAnimationOptions)animationOptionsFromAnimationCurve:(UIViewAnimationCurve)curve {
  switch (curve) {
    case UIViewAnimationCurveEaseInOut:
      return UIViewAnimationOptionCurveEaseInOut;
    case UIViewAnimationCurveEaseIn:
      return UIViewAnimationOptionCurveEaseIn;
    case UIViewAnimationCurveEaseOut:
      return UIViewAnimationOptionCurveEaseOut;
    case UIViewAnimationCurveLinear:
      return UIViewAnimationOptionCurveLinear;
  }
}

@end
