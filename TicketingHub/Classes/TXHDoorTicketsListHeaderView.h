//
//  TXHDoorTicketsListHeaderView.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 27/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHDoorTicketsListHeaderView : UICollectionReusableView

- (void)setAttending:(NSUInteger)attending;
- (void)setTotal:(NSUInteger)total;
- (void)setDate:(NSDate *)date;

@end
