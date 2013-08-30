//
//  TXHSalesInformationHeader.m
//  TicketingHub
//
//  Created by Mark on 08/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesInformationHeader.h"

@interface TXHSalesInformationHeader ()

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;

@end

@implementation TXHSalesInformationHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setTierTitle:(NSString *)tierTitle {
    self.headerTitle.text = tierTitle;
}
@end
