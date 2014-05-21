//
//  TXHSalesSummaryCell.m
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesSummaryItemCell.h"
#import "TXHProductsManager.h"

@interface TXHSalesSummaryItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation TXHSalesSummaryItemCell

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = [NSString stringWithFormat:@"+ %@",title];
}

- (void)setPrice:(NSString *)price
{
    self.priceLabel.text = price;
}

@end
