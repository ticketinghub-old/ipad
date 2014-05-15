//
//  TXHCardView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHCardView.h"

#import "TXHCardBackView.h"
#import "TXHCardFrontView.h"

#import "TXHCardView+TXHCustomXIB.h"

#import <Block-KVO/MTKObserving.h>

@interface TXHCardView ()

@property (nonatomic, strong) IBOutlet TXHCardBackView  *cardBackView;
@property (nonatomic, strong) IBOutlet TXHCardFrontView *cardFrontView;

@property (nonatomic, assign, getter = isFliped) BOOL fliped;
@property (readwrite, assign, nonatomic, getter = isValid) BOOL valid;

@property (nonatomic, assign) BOOL frontSideValid;
@property (nonatomic, assign) BOOL backSideValid;

@end

@implementation TXHCardView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self)
        return nil;

    [TXHCardView loadtxhCardViewWithOwner:self];
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithFrontView:(TXHCardFrontView *)frontView backView:(TXHCardBackView *)backView
{
    if (!(self = [super init]))
        return nil;
    
    _cardBackView  = backView;
    _cardFrontView = frontView;

    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds   = NO;
    
    [self map:@keypath(self.cardFrontView.valid) to:@keypath(self.frontSideValid) null:nil];
    [self map:@keypath(self.cardBackView.valid) to:@keypath(self.backSideValid) null:nil];
    
    [self updateView];
}


- (void)updateView
{
    UIView *currentView = self.fliped ? self.cardBackView : self.cardFrontView;
    self.bounds = currentView.bounds;

    if (!currentView.superview)
    {
        [self removeAllSubviews];
        [self addSubview:currentView];
    }
}

- (void)flipToCardSide:(TXHCardSide)cardSide
{
    if (cardSide == [self currentCardSide])
        return;
    
    UIView *fromView = [self visibleCardView];
    UIView *toView = [self hiddenCardView];
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:[self cardTransitionOption]
                    completion:^(BOOL finished) {
                        if (finished)
                            [toView becomeFirstResponder];
                    }];
}



- (void)setFrontSideValid:(BOOL)frontSideValid
{
    _frontSideValid = frontSideValid;
    
    if (_frontSideValid && !self.fliped)
        [self flipToCardSide:TXHCardSideBack];
    
    [self checkValid];
}

- (void)setBackSideValid:(BOOL)backSideValid
{
    _backSideValid = backSideValid;
    
    [self checkValid];
}

- (void)checkValid
{
    self.valid = self.backSideValid && (self.skipFronSide || self.frontSideValid);
}

- (TXHCardSide)currentCardSide
{
    return self.fliped ? TXHCardSideBack : TXHCardSideFront;
}

- (UIView *)visibleCardView
{
    return self.fliped ? self.cardBackView : self.cardFrontView;
}

- (UIView *)hiddenCardView
{
    return self.fliped ? self.cardFrontView : self.cardBackView;
}

- (void)setSkipFronSide:(BOOL)skipFronSide
{
    _skipFronSide = skipFronSide;
    
    if (skipFronSide)
        [self flipToCardSide:TXHCardSideBack];
}

- (UIViewAnimationOptions)cardTransitionOption
{
    return self.fliped ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
}

- (PKCard *)card
{
    PKCardCVC *cvc           = self.cardBackView.cardCVC;
    PKCardExpiry *expiry     = self.cardFrontView.cardExpiry;
    PKCardNumber *cardNumber = self.cardFrontView.cardNumber;
    
    PKCard *card = [[PKCard alloc] init];
    
    card.number   = [cardNumber string];
    card.cvc      = [cvc string];
    card.expMonth = [expiry month];
    card.expYear  = [expiry year];
    
    return card;
}

@end
