//
//  TXHVariation.h
//  TicketingHub
//
//  Created by Mark on 15/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHVariationOption : NSObject

@property (assign, nonatomic) NSTimeInterval  time;
@property (assign, nonatomic) NSTimeInterval  duration;
@property (strong, nonatomic) NSString        *title;

@end

@interface TXHVariation_old : NSObject

@property (strong, nonatomic) NSDate    *date;
@property (strong, nonatomic) NSString  *reference;
@property (strong, nonatomic) NSArray   *options;

- (id)initWithData:(NSDictionary *)data;

@end
