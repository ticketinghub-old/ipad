//
//  TXHSalesSummaryHeader.h
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHSalesSummaryHeader;

@protocol TXHSalesSummaryHeaderDelegate <NSObject>

- (void)txhSalesSummaryHeaderIsExpandedDidChange:(TXHSalesSummaryHeader *)header;

@end

@interface TXHSalesSummaryHeader : UICollectionReusableView

@property (weak, nonatomic) id<TXHSalesSummaryHeaderDelegate> delegate;

@property (assign, nonatomic,getter = isExpanded) BOOL expanded;

@property (strong, nonatomic) NSString *ticketTitle;
@property (strong, nonatomic) NSString *ticketTotalPrice;

@property (assign, nonatomic) NSUInteger section;

@property (assign, nonatomic) BOOL canExpand;

@end
