//
//  TXHDoorTicketCell.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 06/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHDoorTicketCell;

@protocol TXHDoorTicketCellDelegate

- (void)txhDoorTicketCellDidChangeSwitch:(TXHDoorTicketCell *)cell;

@end

@interface TXHDoorTicketCell : UITableViewCell


- (void)setIsFirstRow:(BOOL)isFirst;
- (void)setIsLastRow:(BOOL)isLast;

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;

- (void)setAttendedAt:(NSDate *)attendedAt;
- (void)setIsLoading:(BOOL)loading;

@end
