//
//  TXHDataSelectionView.h
//  TicketingHub
//
//  Created by Mark on 19/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHBaseDataEntryView.h"

@interface TXHDataSelectionView : TXHBaseDataEntryView

@property (strong, nonatomic) NSArray *selectionList;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *placeholder;

- (void)reset;


@end
