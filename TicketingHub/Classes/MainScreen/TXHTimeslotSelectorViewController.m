//
//  TXHTimeslotSelectorViewController.m
//  TicketingHub
//
//  Created by Mark on 23/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTimeslotSelectorViewController.h"
#import "TXHTimeSlot.h"

@interface TXHTimeslotSelectorViewController ()

@end

@implementation TXHTimeslotSelectorViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTimeSlots:(NSArray *)timeSlots {
    _timeSlots = timeSlots;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#pragma unused (tableView)
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#pragma unused (tableView, section)
    // Return the number of rows in the section.
    return self.timeSlots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    TXHTimeSlot *cellTimeSlot = self.timeSlots[indexPath.row];
    
    NSString *timeString = cellTimeSlot.title;
    cell.textLabel.text = timeString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma unused (tableView)
    TXHTimeSlot *timeSlot = self.timeSlots[indexPath.row];
    [self.delegate timeSlotSelectorViewController:self didSelectTime:@(timeSlot.timeSlotStart)];
}

#pragma mark - Popover methods

- (CGSize)contentSizeForViewInPopover
{
    // Calculate height to present based on the number of timeslots available
    return CGSizeMake(320.0f, 480.0f);
}

@end
