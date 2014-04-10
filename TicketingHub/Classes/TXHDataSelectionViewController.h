//
//  TXHDataSelectionViewController.h
//  TicketingHub
//
//  Created by Mark on 19/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TXHDataSelectionDelegate;

@interface TXHDataSelectionViewController : UITableViewController

// A delegate receiving quantity selection
@property (weak, nonatomic) id <TXHDataSelectionDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

// An array, or dictionary, of items.  if items contains a dictionary there is assumed to be one item within each of the sections.  Dictionary keys are used as section titles.  Values are expected to contain an array of items for the section.
@property (strong, nonatomic) id items;

@end



@protocol TXHDataSelectionDelegate <NSObject>

- (void)dataSelectionViewController:(TXHDataSelectionViewController *)controller didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end