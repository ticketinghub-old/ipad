//
//  TXHDataSelectionViewController.m
//  TicketingHub
//
//  Created by Mark on 19/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHDataSelectionViewController.h"

@interface TXHDataSelectionViewController ()

@end

@implementation TXHDataSelectionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if ([self.items isKindOfClass:[NSDictionary class]]) {
        NSDictionary *itemsDictionary = self.items;
        return itemsDictionary.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([self.items isKindOfClass:[NSArray class]]) {
        NSArray *itemsArray = self.items;
        return itemsArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.items isKindOfClass:[NSDictionary class]]) {
        [self configureCell:cell forDictionaryAtIndexPath:indexPath];
    } else {
        [self configureCell:cell forIndex:indexPath.row];
    }
}

- (void)configureCell:(UITableViewCell *)cell forIndex:(NSUInteger)index {
    id result = [self.items objectAtIndex:index];
    if ([result isKindOfClass:[NSString class]]) {
        cell.textLabel.text = result;
    }
}

- (void)configureCell:(UITableViewCell *)cell forDictionaryAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate dataSelectionViewController:self didSelectItemAtIndexPath:indexPath];
}

@end
