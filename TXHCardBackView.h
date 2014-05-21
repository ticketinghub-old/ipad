//
//  TXHCardBackView.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PaymentKit/PKCardCVC.h>
#import <PaymentKit/PKCardType.h>

@class TXHCardBackView;

@protocol TXHCardBackViewDelegate <NSObject>

@optional
- (void)txhCardBackView:(TXHCardBackView *)backView didFinishValid:(BOOL)valid;
- (void)txhCardBackViewDidStartEditing:(TXHCardBackView *)backView;

@end



@interface TXHCardBackView : UIView

@property (nonatomic, assign) PKCardType cardType;
@property (nonatomic, strong, readonly) PKCardCVC *cardCVC;
@property (nonatomic, weak) id<TXHCardBackViewDelegate> delegate;

- (void)reset;
- (void)setCardCvcFont:(UIFont *)font;

- (void)setValidColor:(UIColor *)color;
- (void)setInvalidColor:(UIColor *)color;

@end
