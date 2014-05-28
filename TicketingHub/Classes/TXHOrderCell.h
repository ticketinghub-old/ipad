//
//  TXHOrderCell.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 28/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHOrderCell : UITableViewCell

- (void)setOrderReference:(NSString *)reference;
- (void)setPrice:(NSString *)string;
- (void)setGuestCount:(NSInteger)guestCount;
- (void)setAttendingCount:(NSInteger)attendingCount;

@end
