//
//  TXHDoorGroupController.m
//  TicketingHub
//
//  Created by Mark on 15/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHDoorGroupController.h"
#import "TXHGroupCell.h"
#import "TXHCommonNames.h"

@interface TXHDoorGroupController ()

@property (nonatomic, strong) NSString  *timeSpan;

@end

@implementation TXHDoorGroupController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
    [self setup];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setup {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(notifyTimeSelected:)
                                               name:doorTimeCellSelected
                                             object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#pragma unused (tableView)
    // Return the number of sections.
  if (self.timeSpan.length > 0) {
    return 5;
  }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#pragma unused (tableView)
  // Return the number of rows in the section.
  if (self.timeSpan.length > 0) {
    return section + 2;
  }
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
#pragma unused (tableView, section)
  return 34;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
#pragma unused (tableView)
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 34.0f)];
    header.backgroundColor = [UIColor lightGrayColor];
    NSString *headerText = [NSString stringWithFormat:@"Group %c - %@", [@(section + 65) charValue], self.timeSpan];
    UIFont *headerFont = [UIFont systemFontOfSize:24.0f];
    NSDictionary *attributes = @{NSFontAttributeName: headerFont};
    CGRect headerTextSizeRect = [headerText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    CGSize headerTextSize = headerTextSizeRect.size;
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, (header.frame.size.height - headerTextSize.height) / 2.0f, headerTextSize.width, headerTextSize.height)];
    headerTitle.font = headerFont;
    headerTitle.backgroundColor = header.backgroundColor;
    headerTitle.text = headerText;
    [header addSubview:headerTitle];
    return header;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//#pragma unused (tableView)
//  return [NSString stringWithFormat:@"Group %c - %@", [@(section + 65) charValue], self.timeSpan];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"groupCellID";
    TXHGroupCell *cell = (TXHGroupCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
  cell.groupTitle.text = [NSString stringWithFormat:@"{%d, %d}", indexPath.section, indexPath.row];
  cell.accessoryType = (indexPath.row % 2) == 0 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone
  ;
    
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

- (void)notifyTimeSelected:(NSNotification *)notification {
  self.timeSpan = [notification object];
  [self.tableView reloadData];
}

@end
