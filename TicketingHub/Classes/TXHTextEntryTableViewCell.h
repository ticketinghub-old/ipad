//
//  TXHTextEntryTableViewCell.h
//  TicketingHub
//
//  Created by Mark on 16/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@interface TXHTextEntryTableViewCell : UITableViewCell

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *placeholder;
@property (copy, nonatomic) NSString *errorMessage;

@end
