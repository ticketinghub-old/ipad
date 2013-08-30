//
//  TXHCreditCardNumberView.h
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHCreditCardNumberView : UIView

@property (strong, nonatomic) id <UITextFieldDelegate> delegate;
@property (strong, nonatomic) NSString *cardType;
@property (strong, nonatomic) NSString *cardNumber;

@end
