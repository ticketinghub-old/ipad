//
//  TXHGateway+CNPHelper.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 12/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHGateway.h"

@interface TXHGateway (CNPHelper)

@property (readonly, nonatomic, assign, getter = isCNPGateway) BOOL CNPGateway;

@end
