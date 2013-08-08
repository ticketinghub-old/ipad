//
//  TXHSalesInformationTextCell.h
//  TicketingHub
//
//  Created by Mark on 08/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesInformationTextCell : UICollectionViewCell

@property (strong, nonatomic) NSString *ticket;

- (void)hasErrors:(BOOL)errors;

@end
