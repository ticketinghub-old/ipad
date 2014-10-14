//
//  TXHCGRectHelpers.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 14/10/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHCGRectHelpers.h"


CG_EXTERN CGRect NormalizeKeyboardFrameRect(CGRect rect)
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        CGRect normalizedRect = CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
        return normalizedRect;
    }
    
    return rect;
}