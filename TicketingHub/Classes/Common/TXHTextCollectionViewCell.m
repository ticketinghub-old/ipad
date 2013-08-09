//
//  TXHTextCollectionViewCell.m
//  TicketingHub
//
//  Created by Mark on 09/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTextCollectionViewCell.h"

@interface TXHTextCollectionViewCell ()

@property (strong, nonatomic) UITextField *textField;

@end

@implementation TXHTextCollectionViewCell

- (void)setupDataContent {
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self updateDataContentView:_textField];
}

@end
