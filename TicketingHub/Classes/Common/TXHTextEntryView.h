//
//  TXHTextEntryView.h
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHBaseDataEntryView.h"

@interface TXHTextEntryView : TXHBaseDataEntryView

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *placeholder;
@property (assign, nonatomic) UIKeyboardType keyboardType;

- (void)reset;

@end
