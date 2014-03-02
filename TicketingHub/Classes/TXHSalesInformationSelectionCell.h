//
//  TXHSalesInformationSelectionCell.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 02/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHSalesInformationSelectionCell;

@protocol TXHSalesInformationSelectionCellDelegate <NSObject>

- (void)txhSalesInformationSelectionCellDidChangeOption:(TXHSalesInformationSelectionCell *)cell;

@end

@interface TXHSalesInformationSelectionCell : UICollectionViewCell

@property (copy, nonatomic) NSString *placeholder;
@property (copy, nonatomic) NSString *value;
@property (copy, nonatomic) NSString *errorMessage;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) id options;

@property (weak, nonatomic) id<TXHSalesInformationSelectionCellDelegate> delegate;

@end
