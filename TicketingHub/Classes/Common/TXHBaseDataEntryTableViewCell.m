//
//  TXHBaseDataEntryTableViewCell.m
//  TicketingHub
//
//  Created by Mark on 16/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHBaseDataEntryTableViewCell.h"

#import "TXHBaseDataEntryView.h"

@interface TXHBaseDataEntryTableViewCell ()

@property (strong, nonatomic) TXHBaseDataEntryView *placeholder;

@end

@implementation TXHBaseDataEntryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // Create placeHolder for the data entry view
    [self setupDataContent];
}

- (void)setupDataContent {
    // Template method.  Nothing for the base class to do!
}

- (NSString *)errorMessage {
    return self.placeholder.errorMessage;
}

- (void)setErrorMessage:(NSString *)errorMessage {
    self.placeholder.errorMessage = errorMessage;
}

- (void)updateDataContentView:(UIView *)dataContentView {
    [self.placeholder updateDataContentView:dataContentView];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.errorMessage = @"";
    [self.placeholder updateDataContentView:nil];
}

@end
