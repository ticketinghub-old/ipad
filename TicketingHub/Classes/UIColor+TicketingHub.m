//
//  UIColor+TicketingHub.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "UIColor+TicketingHub.h"

@implementation UIColor (TicketingHub)


+ (UIColor *)txhDarkBlueColor
{
    static UIColor *customBackgroundColour = nil;
    
    if (!customBackgroundColour) {
        customBackgroundColour = [UIColor colorWithRed:38.0f / 255.0f
                                                 green:67.0f / 255.0f
                                                  blue:90.0f / 255.0f
                                                 alpha:1.0f];
    }
    
    return customBackgroundColour;
}

@end
