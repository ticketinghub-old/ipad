//
//  TXHDateSelectorViewController.h
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import UIKit;

@class TXHTicketingHubClient;
@class TXHDateSelectorViewController;

@protocol TXHDateSelectorViewDelegate <NSObject>

- (void)dateSelectorViewController:(TXHDateSelectorViewController *)controller didSelectDate:(NSDate *)date;

@end


@interface TXHDateSelectorViewController : UIViewController

/** 
 A reference to the network library
 */
@property (strong, nonatomic) TXHTicketingHubClient *ticketingHubClient;

/** 
 A delegate to handle date selection
 */
@property (weak, nonatomic) id <TXHDateSelectorViewDelegate> delegate;

@end

