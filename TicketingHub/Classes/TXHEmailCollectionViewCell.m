//
//  TXHEmailCollectionViewCell.m
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHEmailCollectionViewCell.h"

@interface TXHEmailCollectionViewCell ()

@property UITextField *textField;

@end

@implementation TXHEmailCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupDataContent {
    [super setupDataContent];
    self.textField.keyboardType = UIKeyboardTypeEmailAddress;
    self.textField.placeholder = @"Email:";
}

@end
