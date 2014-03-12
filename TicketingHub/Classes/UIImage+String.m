//
//  UIImage+String.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 06/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "UIImage+String.h"

@implementation UIImage (String)

+ (UIImage *)imageWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color
{
    if (!color) color = [UIColor blackColor];
    if (!font)  font  = [UIFont systemFontOfSize:17];
    
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSForegroundColorAttributeName : color};

    // would have to round to even number to avaoid misalligned image in 3rd party lib
    CGSize size = CGSizeMake(38,16);// [string sizeWithAttributes:attributes];

    CGFloat scale = 1.0;
    if([[UIScreen mainScreen]respondsToSelector:@selector(scale)]) {
        CGFloat tmp = [[UIScreen mainScreen]scale];
        if (tmp > 1.5) {
            scale = 2.0;
        }
    }
    
    if(scale > 1.5) {
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    [string drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:attributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;

}

@end
