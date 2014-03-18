//
//  TXHSalesSummaryFooter.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 18/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesSummaryFooter : UICollectionReusableView

- (void)setTaxPriceText:(NSString *)taxPriceText;
- (void)setTotalPriceText:(NSString *)totalPriceText;

@end
