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
    static UIColor *color = nil;
    
    if (!color)
        color = [UIColor colorWithRed:38.0f / 255.0f
                                green:67.0f / 255.0f
                                 blue:90.0f / 255.0f
                                alpha:1.0f];
    
    return color;
}

+ (UIColor *)txhBlueColor
{
    static UIColor *color = nil;
    
    if (!color)
        color = [UIColor colorFromHexString:@"#2A7BB7" alpha:1.0];
    
    return color;
}

+ (UIColor *)txhButtonBlueColor
{
    static UIColor *color = nil;
    
    if (!color)
        color = [UIColor colorWithRed:41.0f / 255.0f
                                green:122.0f / 255.0f
                                 blue:183.0f / 255.0f
                                alpha:1.0f];
    
    return color;
}


+ (UIColor *)txhGreenColor
{
    static UIColor *color = nil;
    
    if (!color)
        color = [UIColor colorWithRed:24.0f / 255.0f
                                green:166.0f / 255.0f
                                 blue:81.0f / 255.0f
                                alpha:1.0f];
    
    return color;
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

+ (UIColor *) colorFromHexString:(NSString *)hexString alpha: (CGFloat)alpha
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
