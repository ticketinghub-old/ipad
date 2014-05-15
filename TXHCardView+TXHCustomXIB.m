//
//  TXHCardView+TXHCustomXIB.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 15/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHCardView+TXHCustomXIB.h"

static NSString * const xibName = @"TXHCustomCardView";

@implementation TXHCardView (TXHCustomXIB)

+ (void)loadtxhCardViewWithOwner:(id)owner;
{
    [[NSBundle mainBundle] loadNibNamed:xibName
                                  owner:owner
                                options:nil];
}

@end
