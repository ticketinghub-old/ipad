//
//  TXHSalesTicketTierCell.h
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXHSalesTicketTierCellDelegate <NSObject>

- (NSInteger)maximumQuantityForTier:(TXHTier*)tier;

@end

@interface TXHSalesTicketTierCell : UITableViewCell

@property (strong, nonatomic) TXHTier *tier;
@property (weak, nonatomic) id<TXHSalesTicketTierCellDelegate> delegate;

@property (copy) void (^quantityChangedHandler)(NSDictionary *);

@end
