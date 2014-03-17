//
//  TXHDoorTicketsTotalHeaderView.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 14/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHDoorTicketsTotalHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;

- (void)setTotalValueString:(NSString *)total;

@end
