//
//  TXHPaymentOption.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 08/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHPaymentOption : NSObject

@property (nonatomic, strong) TXHGateway *gateway;
@property (nonatomic, copy  ) NSString   *displayName;
@property (nonatomic, copy  ) NSString   *segueIdentifier;

@end
