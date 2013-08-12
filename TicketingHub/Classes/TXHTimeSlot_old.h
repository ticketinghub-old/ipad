//
//  TXHTimeSlot_old.h
//  TicketingHub
//
//  Created by Mark on 16/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHTimeSlot_old : NSObject

@property (strong, nonatomic)   NSDate          *date;
@property (assign, nonatomic)   NSTimeInterval  timeSlotStart;
@property (assign, nonatomic)   NSTimeInterval  timeSlotEnd;
@property (assign, nonatomic)   NSTimeInterval  duration;
@property (readonly, nonatomic) BOOL            openEnded;
@property (strong, nonatomic)   NSString        *title;

@end
