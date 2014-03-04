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

+ (UIColor *)txhFieldErrorBackgroundColor
{
    static UIColor *_errorBackgroundColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _errorBackgroundColor = [UIColor colorWithRed:255.0f / 255.0f
                                                green:213.0f / 255.0f
                                                 blue:216.0f / 255.0f
                                                alpha:1.0f];
    });
    return _errorBackgroundColor;
}

+ (UIColor *)txhFieldNormalBackgroundColor
{
    static UIColor *_normalBackgroundColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _normalBackgroundColor = [UIColor colorWithRed:238.0f / 255.0f
                                                 green:241.0f / 255.0f
                                                  blue:243.0f / 255.0f
                                                 alpha:1.0f];
    });
    return _normalBackgroundColor;
}

+ (UIColor *)txhFieldErrorTextColor
{
    static UIColor *_errorTextColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _errorTextColor = [UIColor redColor];
    });
    return _errorTextColor;
}

+ (UIColor *)txhFieldNormalTextColor
{
    static UIColor *_normalTextColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _normalTextColor = [UIColor colorWithRed:37.0f / 255.0f
                                           green:16.0f / 255.0f
                                            blue:87.0f / 255.0f
                                           alpha:1.0f];
    });
    return _normalTextColor;
}

+ (UIColor *)txhFieldPlaceholderTextColor
{
    static UIColor *_normalTextColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _normalTextColor = [UIColor colorWithRed:37.0f / 255.0f
                                           green:16.0f / 255.0f
                                            blue:87.0f / 255.0f
                                           alpha:0.5f];
    });
    return _normalTextColor;
}

@end
