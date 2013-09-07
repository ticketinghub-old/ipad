//
//  TXHSelectionEntryTableViewCell.m
//  TicketingHub
//
//  Created by Mark on 20/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSelectionEntryTableViewCell.h"

#import "TXHDataSelectionView.h"

@interface TXHSelectionEntryTableViewCell ()

@property TXHDataSelectionView *placeholder;

@end

@implementation TXHSelectionEntryTableViewCell

- (void)setupDataContent {
    [super setupDataContent];
    self.placeholder = [[TXHDataSelectionView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:self.placeholder];
    self.placeholder.tintColor = self.contentView.tintColor;
}

- (TXHDataSelectionView *)field {
    return self.placeholder;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.field reset];
}

@end
