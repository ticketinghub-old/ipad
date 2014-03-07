//
//  UIColor+TicketingHub.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TicketingHub)

+ (UIColor *)txhDarkBlueColor;
+ (UIColor *)txhGreenColor;


+ (UIColor *)txhFieldErrorBackgroundColor;
+ (UIColor *)txhFieldNormalBackgroundColor;
+ (UIColor *)txhFieldErrorTextColor;
+ (UIColor *)txhFieldNormalTextColor;
+ (UIColor *)txhFieldPlaceholderTextColor;

+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;
@end
