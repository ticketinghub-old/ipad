//
//  TXHTextEntryTableViewCell.h
//  TicketingHub
//
//  Created by Mark on 16/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHBaseDataEntryTableViewCell.h"

#import "TXHTextEntryView.h"

@interface TXHTextEntryTableViewCell : TXHBaseDataEntryTableViewCell

@property (readonly, nonatomic) TXHTextEntryView *textField;

@end
