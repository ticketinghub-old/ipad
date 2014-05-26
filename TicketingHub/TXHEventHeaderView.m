//
//  TXHEventHeaderView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHEventHeaderView.h"

@interface TXHEventHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TXHEventHeaderView

- (void)setTitleText:(NSString *)text
{
    self.titleLabel.text = text;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self setTitleText:nil];
}

@end
