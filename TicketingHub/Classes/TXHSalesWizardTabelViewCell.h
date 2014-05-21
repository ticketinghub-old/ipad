//
//  TXHSalesWizardTabelViewCell.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 17/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHSalesWizardTabelViewCell : UITableViewCell

- (void)setTite:(NSString *)title;
- (void)setDetails:(NSString *)details;
- (void)setNumber:(NSUInteger)number;
- (void)setIsCurrent:(BOOL)current;
- (void)setCompleted:(BOOL)completed;


@end
