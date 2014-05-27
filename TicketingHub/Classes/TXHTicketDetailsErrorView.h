//
//  TXHTicketDetailsErrorView.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 17/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TXHTicketDetailsErrorType)
{
    TXHTicketDetailsEarlyError,
    TXHTicketDetailsCancelledError,
    TXHTicketDetailsExpiredError
};

@interface TXHTicketDetailsErrorView : UIView

- (void)showWithError:(TXHTicketDetailsErrorType)errorType date:(NSDate *)date;
- (void)hide;

@end
