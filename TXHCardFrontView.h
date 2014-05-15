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

@interface TXHCardFrontView : UIView

@property (readonly, assign, nonatomic, getter = isValid) BOOL valid;

@property (readonly, strong, nonatomic) PKCardNumber *cardNumber;
@property (readonly, strong, nonatomic) PKCardExpiry *cardExpiry;


@end
