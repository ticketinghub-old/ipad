//
//  TXHDoorTicketsDateHeaderView.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 14/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHDoorTicketsDateHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateValueLabel;

- (void)setDate:(NSDate *)date;

@end
