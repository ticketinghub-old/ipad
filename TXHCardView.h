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

@class TXHCardView;

typedef NS_ENUM(NSUInteger, TXHCardSide)
{
    TXHCardSideFront,
    TXHCardSideBack
};

@protocol TXHCardViewDelegate <NSObject>

@optional
- (void)txhCardView:(TXHCardView *)cardView didFinishValid:(BOOL)valid withCardInfo:(PKCard *)card;
- (void)txhCardView:(TXHCardView *)cardView didFlipToSide:(TXHCardSide)cardSide;
- (void)txhCardViewDidStartEditing:(TXHCardView *)cardView;
- (void)txhCardViewDidCancel:(TXHCardView *)cardView;

@end



@interface TXHCardView : UIView

@property (readonly) PKCard *card;

@property (assign, nonatomic) BOOL enabled;
@property (nonatomic, assign) BOOL skipFronSide;
@property (nonatomic, assign, readonly, getter = isValid) BOOL valid;

@property (nonatomic, readonly) TXHCardSide cardSide;

@property (nonatomic, weak) IBOutlet id<TXHCardViewDelegate> delegate;

@property (nonatomic, strong, readonly) TXHCardBackView  *cardBackView;
@property (nonatomic, strong, readonly) TXHCardFrontView *cardFrontView;

- (instancetype)initWithFrontView:(TXHCardFrontView *)frontView backView:(TXHCardBackView *)backView;

- (void)flipToCardSide:(TXHCardSide)cardSide;

- (void)reset;


@end
