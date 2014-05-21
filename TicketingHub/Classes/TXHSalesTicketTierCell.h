//
//  TXHSalesTicketTierCell.h
//  TicketingHub
//
//  Created by Mark on 31/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHSalesTicketTierCell;

@protocol TXHSalesTicketTierCellDelegate <NSObject>

- (NSInteger)maximumQuantityForCell:(TXHSalesTicketTierCell *)cell;

@end

@interface TXHSalesTicketTierCell : UICollectionViewCell

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *priceString;

@property (copy, nonatomic) NSString *tierIdentifier;

@property (assign, nonatomic) NSInteger selectedQuantity;

@property (weak, nonatomic) id<TXHSalesTicketTierCellDelegate> delegate;

@property (copy) void (^quantityChangedHandler)(NSDictionary *);

@end
