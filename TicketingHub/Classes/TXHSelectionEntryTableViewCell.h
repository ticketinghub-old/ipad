//
//  TXHSelectionEntryTableViewCell.h
//  TicketingHub
//
//  Created by Mark on 20/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHBaseDataEntryTableViewCell.h"

@class TXHDataSelectionView;

@interface TXHSelectionEntryTableViewCell : TXHBaseDataEntryTableViewCell

@property (readonly, nonatomic) TXHDataSelectionView *field;

@end
