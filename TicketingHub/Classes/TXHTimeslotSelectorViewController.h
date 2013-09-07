//
//  TXHTimeslotSelectorViewController.h
//  TicketingHub
//
//  Created by Mark on 23/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHTimeSlot_old;

@protocol TXHTimeSlotSelectorDelegate;

@interface TXHTimeslotSelectorViewController : UITableViewController

// A delegate that will receive timeSlot selection
@property (weak, nonatomic) id <TXHTimeSlotSelectorDelegate> delegate;

@property (strong, nonatomic) NSArray *timeSlots;

@end

@protocol TXHTimeSlotSelectorDelegate <NSObject>

- (void)timeSlotSelectorViewController:(TXHTimeslotSelectorViewController *)controller didSelectTime:(TXHTimeSlot_old *)time;

@end