//
//  TXHSalesSummaryFooter.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHSalesSummaryFooter.h"

@interface TXHSalesSummaryFooter ()

@property (weak, nonatomic) IBOutlet UILabel *taxValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;

@end

@implementation TXHSalesSummaryFooter

- (void)setTaxPriceText:(NSString *)taxPriceText
{
    self.taxValueLabel.text = taxPriceText;
}

- (void)setTotalPriceText:(NSString *)totalPriceText
{
    self.totalValueLabel.text = totalPriceText;
}

@end
