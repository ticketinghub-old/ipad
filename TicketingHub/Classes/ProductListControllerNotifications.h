//
//  ProductListControllerNotifications.h
//  TicketingHub
//
//  Created by Abizer Nasir on 17/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

/**
 Notification sent by the ProductListController when the selected venue is changed.
 
 The `object` will be the instance of ProductListController
 The `userInfo` contain the following key:value
      TXHSelectedProduct : a reference to the TXHProduct object that has been selected. The object is in the main managed object context.
 */
extern NSString * const TXHProductChangedNotification;

/**
 The key used by the `userInfo` dictionary containing the selected venue reference
 */
extern NSString * const TXHSelectedProduct;