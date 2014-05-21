//
//  TXHSalesUpgradeHeader.h
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHSalesUpgradeHeader;

@protocol TXHSalesUpgradeHeaderDelegate <NSObject>

- (void)txhSalesUpgradeHeaderIsExpandedDidChange:(TXHSalesUpgradeHeader *)header;

@end

@interface TXHSalesUpgradeHeader : UICollectionReusableView

@property (weak, nonatomic) id<TXHSalesUpgradeHeaderDelegate> delegate;

@property (assign, nonatomic,getter = isExpanded) BOOL expanded;

@property (strong, nonatomic) NSString *ticketTitle;

@property (assign, nonatomic) NSUInteger section;

@end
