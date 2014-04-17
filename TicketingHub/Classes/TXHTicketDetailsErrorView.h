//
//  TXHTicketDetailsErrorView.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 17/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHTicketDetailsErrorView : UIView

- (void)showWithExpirationDate:(NSDate *)expirationDate;
- (void)hide;

@end
