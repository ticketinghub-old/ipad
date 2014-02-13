//
//  FetchedResultsControllerDataSource.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewConfigurationBlock.h"

@interface FetchedResultsControllerDataSource : NSObject <UITableViewDataSource>

- (id)initWithFetchedResultsController:(NSFetchedResultsController *)aController
                             tableView:(UITableView *)aTableView
                        cellIdentifier:(NSString *)aCellIdentifier
                    configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)performFetch:(NSError **)error;

@end
