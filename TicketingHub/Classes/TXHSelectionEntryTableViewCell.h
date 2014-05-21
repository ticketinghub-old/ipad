//
//  TXHSelectionEntryTableViewCell.h
//  TicketingHub
//
//  Created by Mark on 20/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@class TXHDataSelectionView;

@interface TXHSelectionEntryTableViewCell : UITableViewCell

@property (copy, nonatomic) NSString *placeholder;
@property (copy, nonatomic) NSString *value;
@property (copy, nonatomic) NSString *errorMessage;
@property (strong, nonatomic) id options;


@end
