//
//  TXHDateSelectorViewController.h
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXHDateSelectorViewDelegate;

@interface TXHDateSelectorViewController : UIViewController

// A delegate that will receive date selection
@property (weak, nonatomic) id <TXHDateSelectorViewDelegate> delegate;

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view;

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item;

- (BOOL)isPopoverVisible;

- (void)dismissPopover;

// Constrain the date picker to a range of dates from which one may be selected.
// Each element contains a dictionary with start & end keys
- (void)constrainToDateRanges:(NSArray *)ranges;

@end

@protocol TXHDateSelectorViewDelegate <NSObject>

- (void)dateSelectorViewController:(TXHDateSelectorViewController *)controller didSelectDate:(NSDate *)date ;

@end