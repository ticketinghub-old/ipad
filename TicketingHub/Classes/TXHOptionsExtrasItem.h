//
//  TXHOptionsExtrasItem.h
//  TicketingHub
//
//  Created by Mark on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHOptionsExtrasItem : NSObject

@property (strong, nonatomic)   NSString  *currencyCode;
@property (strong, nonatomic)   NSString  *description;
@property (strong, nonatomic)   NSMutableArray  *descriptionArray;
@property (strong, nonatomic)   NSNumber  *price;
@property (readonly, nonatomic) NSString  *formattedPrice;
@property (strong, nonatomic)   NSNumber  *quantity;

@end
