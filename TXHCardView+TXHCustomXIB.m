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
    
    NSString *fontName = @"Halter";
    UIFont *cardNumberFont = [UIFont fontWithName:fontName size:23.0];
    UIFont *cardExpiryFont = [UIFont fontWithName:fontName size:18.0];
    
    [owner.cardFrontView setCardExpiryFont:cardExpiryFont];
    [owner.cardFrontView setCardNumberFont:cardNumberFont];
    
    [owner.cardBackView setCardCvcFont:cardNumberFont];
}

@end
