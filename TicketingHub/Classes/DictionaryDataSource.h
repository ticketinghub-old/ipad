//
//  DictionaryDataSource.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 11/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewConfigurationBlock.h"

@interface DictionaryDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSDictionary *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
