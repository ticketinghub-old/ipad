//
//  TXHDoorTicketCell.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 06/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHDoorTicketCell : UITableViewCell

- (void)setIsFirstRow:(BOOL)isFirst;
- (void)setIsLastRow:(BOOL)isLast;

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;

- (void)setAttendedAt:(NSDate *)attendedAt;
- ()

@end
