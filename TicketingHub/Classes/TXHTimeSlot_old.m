//
//  TXHTimeSlot_old.m
//  TicketingHub
//
//  Created by Mark on 16/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTimeSlot_old.h"

@implementation TXHTimeSlot_old

- (BOOL)openEnded {
  return ((self.duration > 0.0f) == NO);
}

@end
