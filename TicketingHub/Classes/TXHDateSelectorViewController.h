//
//  TXHDateSelectorViewController.h
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHTicketingHubClient;

@protocol TXHDateSelectorViewDelegate;

@interface TXHDateSelectorViewController : UIViewController

@property (strong, nonatomic) TXHTicketingHubClient *ticketingHubClient;

// A delegate that will receive date selection
@property (weak, nonatomic) id <TXHDateSelectorViewDelegate> delegate;

// Constrain the date picker to a range of dates from which one may be selected.
// Each element contains a dictionary with start & end keys
- (void)constrainToDateRanges:(NSArray *)ranges;

@end

@protocol TXHDateSelectorViewDelegate <NSObject>

- (void)dateSelectorViewController:(TXHDateSelectorViewController *)controller didSelectDate:(NSDate *)date ;

@end