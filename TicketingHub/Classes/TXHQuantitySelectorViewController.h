//
//  TXHQuantitySelectorViewController.h
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXHQuantitySelectorDelegate;

@interface TXHQuantitySelectorViewController : UITableViewController

// A delegate receiving quantity selection
@property (strong, nonatomic) id <TXHQuantitySelectorDelegate> delegate;

@property (assign, nonatomic) NSUInteger maximumQuantityAllowed;
@property (assign, nonatomic) NSUInteger currentQuantitySelected;

@end



@protocol TXHQuantitySelectorDelegate <NSObject>

- (void)quantitySelectorViewController:(TXHQuantitySelectorViewController *)controller didSelectQuantity:(NSUInteger)quantity;

@end