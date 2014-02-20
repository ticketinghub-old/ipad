//
//  TXHDateSelectorViewController.h
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import UIKit;
#import <TapkuLibrary/TapkuLibrary.h>

@class TXHDateSelectorViewController;

@protocol TXHDateSelectorViewDelegate <NSObject>

- (void)dateSelectorViewController:(TXHDateSelectorViewController *)controller didSelectAvailability:(TXHAvailability *)availability;

@end

@interface TXHDateSelectorViewController : TKCalendarMonthTableViewController


@property (weak, nonatomic) id <TXHDateSelectorViewDelegate> delegate;

@end

