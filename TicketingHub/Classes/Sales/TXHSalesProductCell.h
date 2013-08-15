//
//  TXHSalesProductCell.h
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesProductCell : UITableViewCell

@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productDescription;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *quantity;

@end
