//
//  TXHDataEntryFieldErrorView.h
//  TicketingHub
//
//  Created by Mark on 09/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHDataEntryFieldErrorView : UIView

@property (strong, nonatomic) NSString *message;

@property (strong, nonatomic) UIColor *messageColor;
@property (strong, nonatomic) UIColor *messageBackgroundColor;

@property (strong, nonatomic) UIFont *textFont;

@end
