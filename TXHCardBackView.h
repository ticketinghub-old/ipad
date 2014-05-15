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

@interface TXHCardBackView : UIView

@property (readonly, strong, nonatomic) PKCardCVC *cardCVC;

@property (nonatomic, assign) PKCardType cardType;
@property (readonly, assign, nonatomic, getter = isValid) BOOL valid;


@end
