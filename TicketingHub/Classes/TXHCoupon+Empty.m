//
//  TXHCoupon+Empty.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 09/09/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHCoupon+Empty.h"

@implementation TXHCoupon (Empty)

+ (instancetype)emptyCoupon
{
    TXHCoupon *coupon = [[TXHCoupon alloc] init];
    coupon.code = NSLocalizedString(@"SALESMAN_NO_COUPON_SELECTED_COUPON", nil);

    return coupon;
}

- (BOOL)isEmpty
{
    return [self.code isEqualToString:NSLocalizedString(@"SALESMAN_NO_COUPON_SELECTED_COUPON", nil)];
}

@end
