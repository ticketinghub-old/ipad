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

@interface TXHCardView () <TXHCardBackViewDelegate, TXHCardFrontViewDelegate>

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
    
    [self addGestureRecognizers];
    
    [self updateView];
}

- (void)addGestureRecognizers
{
    [self addTapGestureRecognizer];
}

- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)tapRecognized:(UITapGestureRecognizer *)tapRecognizer
{
    [self startEditingCurrentCardSide];
}

- (void)startEditingCurrentCardSide
{
    [[self visibleCardView] becomeFirstResponder];
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
    if (cardSide == [self cardSide])
        return;
    
    UIView *fromView = [self visibleCardView];
    UIView *toView = [self hiddenCardView];
    
    
    // workaround to keep keyboard while moving to back card view
    UITextField * tmpTF;
    if (cardSide == TXHCardSideBack)
    {
        tmpTF = [[UITextField alloc] init];
        tmpTF.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:tmpTF];
        [tmpTF becomeFirstResponder];
    }
    
    if ([self.delegate respondsToSelector:@selector(txhCardView:didFlipToSide:)])
        [self.delegate txhCardView:self didFlipToSide:cardSide];

    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:[self cardTransitionOption]
                    completion:^(BOOL finished) {
                        if (finished)
                        {
                            if ((self.fliped = (cardSide == TXHCardSideBack)))
                            {
                                [toView becomeFirstResponder];
                                [tmpTF removeFromSuperview];
                            }
                        }
                    }];
}

- (void)reset
{
    [self.cardFrontView reset];
    [self.cardBackView reset];
    
    [self flipToCardSide:TXHCardSideFront];
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    self.userInteractionEnabled = enabled;
    self.alpha = enabled ? 1.0 : 0.5;
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

- (void)setCardBackView:(TXHCardBackView *)cardBackView
{
    _cardBackView = cardBackView;
    cardBackView.delegate = self;
}

- (void)setCardFrontView:(TXHCardFrontView *)cardFrontView
{
    _cardFrontView = cardFrontView;
    cardFrontView.delegate = self;
}

- (void)setValid:(BOOL)valid
{
    _valid = valid;
    
    if (valid && [self.delegate respondsToSelector:@selector(txhCardView:didFinishValid:withCardInfo:)])
        [self.delegate txhCardView:self didFinishValid:valid withCardInfo:self.card];
}

- (void)checkValid
{
    self.valid = self.backSideValid && (self.skipFronSide || self.frontSideValid);
}

- (TXHCardSide)cardSide
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

- (BOOL)resignFirstResponder
{
    return [[self visibleCardView] resignFirstResponder];
}

-(BOOL)becomeFirstResponder
{
    return [[self visibleCardView] becomeFirstResponder];
}

#pragma mark - TXHCardBackViewDelegate

- (void)txhCardBackView:(TXHCardBackView *)backView didFinishValid:(BOOL)valid
{
    self.backSideValid = valid;
}

- (void)txhCardBackViewDidStartEditing:(TXHCardBackView *)backView
{
    [self beganEditing];
}

#pragma mark - TXHCardFrontViewDelegate

- (void)txhCardFrontView:(TXHCardFrontView *)backView didFinishValid:(BOOL)valid
{
    self.frontSideValid = valid;
}

- (void)txhCardFrontViewDidStartEditing:(TXHCardFrontView *)backView
{
    [self beganEditing];
}

- (void)beganEditing
{
    if ([self.delegate respondsToSelector:@selector(txhCardViewDidStartEditing:)])
        [self.delegate txhCardViewDidStartEditing:self];
}

@end
