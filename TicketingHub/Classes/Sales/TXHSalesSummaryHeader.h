//
//  TXHSalesSummaryHeader.h
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesSummaryHeader : UICollectionReusableView

@property (strong, nonatomic) NSAttributedString *ticketTitle;
@property (strong, nonatomic) NSNumber *totalPrice;

@property (assign, nonatomic) NSUInteger section;

@property (assign, nonatomic) BOOL isExpanded;

@end
