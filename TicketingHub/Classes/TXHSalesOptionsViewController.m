//
//  TXHSalesOptionsViewController.m
//  TicketingHub
//
//  Created by Mark on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesOptionsViewController.h"

#import <iOS-api/iOS-api.h>
#import "TXHTicketingHubClient+AppExtension.h"
#import "TXHCommonNames.h"
#import "TXHSalesOptionsCell.h"
#import "TXHOptionsExtrasItem.h"
#import "TXHTimeSlot_old.h"

#define TIER_SECTION 0

@interface TXHSalesOptionsViewController ()

@property (strong, nonatomic) NSMutableArray *options;

@end

@implementation TXHSalesOptionsViewController

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
  self.options = [NSMutableArray array];
  
  for (int i = 0; i < 5; i++) {
    TXHOptionsExtrasItem *item = [[TXHOptionsExtrasItem alloc] init];
    item.price = @(13.7f * (i + 1));
    item.quantity = @(i + (i * 3));
    item.description = [NSString stringWithFormat:@"Desc %d", i+ 1];
    item.currencyCode = @"EUR";
    [self.options addObject:item];
  }
  
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeslotSelected:) name:NOTIFICATION_TIMESLOT_SELECTED object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma unused (tableView)
#pragma unused (section)
  
  // Return the number of rows in the section.
  return self.options.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
#pragma unused (tableView)
  switch (section) {
    case TIER_SECTION:
      return NSLocalizedString(@"Ticket tier type", @"Ticket tier type");
    default:
      return nil;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"optionsCell";
  TXHSalesOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  // Configure the cell...
  cell.optionItem = self.options[indexPath.row];
  
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Notifications

//- (void)timeslotSelected:(NSNotification *)notification {
//  TXHTimeSlot *timeSlot = notification.object;
////  [[TXHServerAccessManager sharedInstance] getTicketOptionsFor:timeSlot];
//}

@end
