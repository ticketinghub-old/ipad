//
//  TXHSalesUpgradeCell.h
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXHUpgrade;
@class TXHProductsManager;
@class TXHSalesUpgradeCell;

@protocol TXHSalesUpgradeCellDelegate <NSObject>
@optional
- (void)txhSalesUpgradeCell:(TXHSalesUpgradeCell *)cell changedTicketsSelection:(NSArray *)selectedTickets forUpgrade:(TXHUpgrade *)upgrade;

@end


@interface TXHSalesUpgradeCell : UITableViewCell

@property (weak, nonatomic) id<TXHSalesUpgradeCellDelegate> delegate;
@property (strong, nonatomic) TXHProductsManager *productManager;

@property (strong, nonatomic, readonly) TXHUpgrade *upgrade;
@property (strong, nonatomic, readonly) NSArray *tickets;

// one setter ot optimize collection view reload
- (void)setUpgrade:(TXHUpgrade *)upgrade withTickets:(NSArray *)tickets selectedTickets:(NSArray *)selectedTickets;

@end
