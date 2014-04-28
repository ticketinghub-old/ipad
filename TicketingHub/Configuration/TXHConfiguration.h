//
//  TXHConfiguration.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 28/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXHConfigurationKeys.h"

#define CONFIGURATION [TXHConfiguration sharedInstance]

@interface TXHConfiguration : NSObject

+ (TXHConfiguration *)sharedInstance;

@property (readonly, nonatomic) NSUserDefaults      *userDefaults;
@property (readonly, nonatomic) NSMutableDictionary *configuration;

@end


@interface TXHConfiguration (subscripts)

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
- (id)objectForKeyedSubscript:(id)key;

@end
