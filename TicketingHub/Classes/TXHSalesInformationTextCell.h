//
//  TXHSalesInformationTextCell.h
//  TicketingHub
//
//  Created by Mark on 08/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHSalesInformationTextCell;

@protocol TXHSalesInformationTextCellDelegate <NSObject>

- (void)txhSalesInformationTextCellDidChangeText:(TXHSalesInformationTextCell *)cell;

@end


@interface TXHSalesInformationTextCell : UICollectionViewCell

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *text;
@property (copy, nonatomic  ) NSString *placeholder;
@property (copy, nonatomic  ) NSString *errorMessage;

@property (weak, nonatomic) id<TXHSalesInformationTextCellDelegate> delegate;

@end
