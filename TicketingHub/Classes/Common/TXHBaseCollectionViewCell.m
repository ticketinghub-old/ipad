//
//  TXHBaseCollectionViewCell.m
//  TicketingHub
//
//  Created by Mark on 09/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHBaseCollectionViewCell.h"

#import "TXHBaseDataEntryView.h"

@interface TXHBaseCollectionViewCell ()

@property (strong, nonatomic) IBOutlet TXHBaseDataEntryView *placeholder;

@end

@implementation TXHBaseCollectionViewCell

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
