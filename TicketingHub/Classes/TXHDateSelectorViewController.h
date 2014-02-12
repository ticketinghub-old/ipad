//
//  TXHDateSelectorViewController.h
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import UIKit;

extern NSString * const DateSelectorViewControllerStoryboardIdentifier;

@class TXHDateSelectorViewController;

@protocol TXHDateSelectorViewDelegate <NSObject>

@optional
/** Handle date selection - optional
 
 The delegate is sent this message when a date is selected in the calendar view.

 @param controller The instance of DateSelectorViewController that sent this message.
 @param date the selected date, the time portion is midnight and should not be relied on.
 */
- (void)dateSelectorViewController:(TXHDateSelectorViewController *)controller didSelectDate:(NSDate *)date;

@end


@interface TXHDateSelectorViewController : UIViewController

/**
 The selected date to be highlighted in the calendar. Only the date portion is used.
 */
@property (strong, nonatomic) NSDate *selectedDate;

/** 
 A delegate to handle date selection
 */
@property (weak, nonatomic) id <TXHDateSelectorViewDelegate> delegate;

@end

