//
//  TXHCardFrontView.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <PaymentKit/PKCardNumber.h>
#import <PaymentKit/PKCardExpiry.h>
#import <PaymentKit/PKTextField.h>

@class TXHCardFrontView;

@protocol TXHCardFrontViewDelegate <NSObject>

@optional
- (void)txhCardFrontView:(TXHCardFrontView *)backView didFinishValid:(BOOL)valid;
- (void)txhCardFrontViewDidStartEditing:(TXHCardFrontView *)backView;

@end



@interface TXHCardFrontView : UIView

@property (nonatomic, strong, readonly) PKCardNumber *cardNumber;
@property (nonatomic, strong, readonly) PKCardExpiry *cardExpiry;

@property (nonatomic, weak) id<TXHCardFrontViewDelegate> delegate;

- (void)reset;
- (void)setCardNumberFont:(UIFont *)font;
- (void)setCardExpiryFont:(UIFont *)font;

- (void)setValidColor:(UIColor *)color;
- (void)setInvalidColor:(UIColor *)color;



@end
