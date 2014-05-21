//
//  TXHCardView+TXHCustomXIB.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 15/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHCardView+TXHCustomXIB.h"
#import "UIColor+TicketingHub.h"

#import "TXHCardBackView.h"
#import "TXHCardFrontView.h"

static NSString * const xibName = @"TXHCustomCardView";

@implementation TXHCardView (TXHCustomXIB)

+ (void)loadtxhCardViewWithOwner:(TXHCardView *)owner;
{
    [[NSBundle mainBundle] loadNibNamed:xibName
                                  owner:owner
                                options:nil];
    
    UIFont *cardFont = [UIFont fontWithName:@"OCRAStd" size:28.0];
    
    [owner.cardFrontView setCardExpiryFont:cardFont];
    [owner.cardFrontView setCardNumberFont:cardFont];
    
    [owner.cardBackView setCardCvcFont:cardFont];
}

@end
