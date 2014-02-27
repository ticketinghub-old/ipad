//
//  TXHDataSelectionViewController.m
//  TicketingHub
//
//  Created by Mark on 19/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHDataSelectionViewController.h"

// TableView data sources
#import "ArrayDataSource.h"
#import "DictionaryDataSource.h"

@interface TXHDataSelectionViewController ()

@property (strong, nonatomic) id<UITableViewDataSource> tableViewDataSource;

@end

@implementation TXHDataSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)setItems:(id)items
{
    _items = items;
    self.tableViewDataSource = [self dataSourceForItems:items
                                     configureCellBlock:^(id cell, id item) {
                                         [self configureCell:cell withItem:item];
                                     }];
    
    self.tableView.dataSource = self.tableViewDataSource;
    [self.tableView reloadData];
}

- (id<UITableViewDataSource>)dataSourceForItems:(id)items
                             configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    if ([items isKindOfClass:[NSArray class]])
    {
        return [[ArrayDataSource alloc] initWithItems:items
                                       cellIdentifier:@"CellIdentifier"
                                   configureCellBlock:aConfigureCellBlock];
    }
    else if ([items isKindOfClass:[NSDictionary class]])
    {
        return [[DictionaryDataSource alloc] initWithItems:items
                                            cellIdentifier:@"CellIdentifier"
                                        configureCellBlock:aConfigureCellBlock];
    }
    return nil;
}

- (void)configureCell:(UITableViewCell *)cell withItem:(id)item
{
    if ([item isKindOfClass:[NSString class]])
    {
        cell.textLabel.text = item;
    }
    else
    {
        cell.textLabel.text = nil;
    }
}

#pragma mark UItableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate dataSelectionViewController:self didSelectItemAtIndexPath:indexPath];
}

@end
