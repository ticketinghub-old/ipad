//
//  TXHDoorTicketsAttendedHeaderView.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 14/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHDoorTicketsAttendedHeaderView;

@protocol TXHDoorTicketsAttendedHeaderViewDelegate <NSObject>

- (void)txhDoorTicketsAttendedHeaderViewDelegateIsExpandedDidChange:(TXHDoorTicketsAttendedHeaderView *)header;

@end

@interface TXHDoorTicketsAttendedHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *ticketsLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendedLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@property (weak, nonatomic) id<TXHDoorTicketsAttendedHeaderViewDelegate> delegate;

@property (assign, nonatomic,getter = isExpanded) BOOL expanded;

- (void)setAttendedCount:(NSNumber *)count;
- (void)setTotalCount:(NSNumber *)count;

@end
