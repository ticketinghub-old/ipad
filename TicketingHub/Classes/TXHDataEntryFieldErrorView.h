//
//  TXHDataEntryFieldErrorView.h
//  TicketingHub
//
//  Created by Mark on 09/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHDataEntryFieldErrorView : UIView

// An error message to be displayed
@property (strong, nonatomic) NSString *message;

// Text colour for the error message
@property (strong, nonatomic) UIColor *messageColor;

// background colour for the error message
@property (strong, nonatomic) UIColor *messageBackgroundColor;

@end
