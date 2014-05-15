//
//  TXHCardView.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXHCardBackView.h"
#import "TXHCardFrontView.h"
#import <PaymentKit/PKCard.h>

typedef NS_ENUM(NSUInteger, TXHCardSide)
{
    TXHCardSideFront,
    TXHCardSideBack
};


@interface TXHCardView : UIView

@property (readonly) PKCard *card;
@property (nonatomic, assign) BOOL skipFronSide;
@property (readonly, assign, nonatomic, getter = isValid) BOOL valid;


- (instancetype)initWithFrontView:(TXHCardFrontView *)frontView backView:(TXHCardBackView *)backView;

- (void)flipToCardSide:(TXHCardSide)cardSide;

- (TXHCardSide)currentCardSide;


@end
