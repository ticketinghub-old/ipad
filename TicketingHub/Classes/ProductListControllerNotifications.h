//
//  ProductListControllerNotifications.h
//  TicketingHub
//
//  Created by Abizer Nasir on 17/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

/**
 Notification sent by the ProductListController when the selected venue is changed.
 
 The `object` will be the instance of ProductListController
 The `userInfo` contain the following key:value
      TXHSelectedVenue : a reference to the TXHVenueMO object that has been selected.
 */
extern NSString * const TXHProductChangedNotification;

/**
 The key used by the `userInfo` dictionary containing the selected venue reference
 */
extern NSString * const TXHSelectedVenue;