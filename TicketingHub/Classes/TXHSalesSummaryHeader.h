//
//  TXHSalesSummaryHeader.h
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHSalesSummaryHeader;


@interface TXHSalesSummaryHeader : UICollectionReusableView

@property (strong, nonatomic) NSString *ticketTitle;
@property (strong, nonatomic) NSString *ticketTotalPrice;

@property (assign, nonatomic) NSUInteger section;

@end
