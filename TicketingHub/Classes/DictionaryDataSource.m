//
//  DictionaryDataSource.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 11/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

// TODO: perform a bit more check if item at path exists

#import "DictionaryDataSource.h"

@interface DictionaryDataSource ()

@property (nonatomic, strong) NSDictionary *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end

@implementation DictionaryDataSource

- (id)init
{
    return nil;
}

- (id)initWithItems:(NSDictionary *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= [[self.items allValues] count])
        return nil;
    
    id item = [self.items allValues][(NSUInteger) indexPath.section];
    
    if ([item isKindOfClass:[NSArray class]] || indexPath.row >= [item count])
        return nil;
    
    return item[(NSUInteger) indexPath.row];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.items allValues][section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}

@end
