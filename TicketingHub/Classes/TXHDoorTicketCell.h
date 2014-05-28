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

- (void)txhDoorTicketCelldidChangeSwitch:(TXHDoorTicketCell *)cell;

@end

@interface TXHDoorTicketCell : UICollectionViewCell

@property (nonatomic, weak) id<TXHDoorTicketCellDelegate> delegate;
@property (nonatomic, readonly) BOOL switchValue;


- (void)setName:(NSString *)name;
- (void)setTierName:(NSString *)tierName;
- (void)setReference:(NSString *)orderReference;
- (void)setPrice:(NSString *)price;
- (void)setActive:(BOOL)active;

- (void)setAttendedAt:(NSDate *)attendedAt animated:(BOOL)animated;
- (void)setIsLoading:(BOOL)loading;

@end
