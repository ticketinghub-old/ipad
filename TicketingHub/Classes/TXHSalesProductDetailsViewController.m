//
//  TXHSalesProductDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesProductDetailsViewController.h"

#import "TXHSalesCompletionViewController.h"
#import "TXHSalesContentProtocol.h"
#import "TXHSalesProductCell.h"
#import "TXHSalesTimerViewController.h"

@interface TXHSalesProductDetailsViewController () <TXHSalesContentProtocol>

// A reference to the timer view controller
@property (retain, nonatomic) TXHSalesTimerViewController *timerViewController;

// A reference to the completion view controller
@property (retain, nonatomic) TXHSalesCompletionViewController *completionViewController;

// A completion block to be run when this step is completed
@property (copy) void (^completionBlock)(void);

// A mutable collection of sections indicating their expanded status.
@property (strong, nonatomic) NSMutableDictionary *sections;

@end

@implementation TXHSalesProductDetailsViewController

@synthesize timerViewController = _timerViewController;
@synthesize completionViewController = _completionViewController;
@synthesize completionBlock = _completionBlock;

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

    __block typeof(self) blockSelf = self;
    self.completionBlock = ^{
        // Update the order for tickets
        NSLog(@"Update order for %@", blockSelf);
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TXHSalesTimerViewController *)timerViewController {
    return _timerViewController;
}

- (void)setTimerViewController:(TXHSalesTimerViewController *)timerViewController {
    _timerViewController = timerViewController;
    [self configureTimerViewController];
}

- (TXHSalesCompletionViewController *)completionViewController {
    return _completionViewController;
}

- (void)setCompletionViewController:(TXHSalesCompletionViewController *)completionViewController {
    _completionViewController = completionViewController;
    [self configureCompletionViewController];
}

- (void (^)(void))completionBlock {
    return _completionBlock;
}

- (void)setCompletionBlock:(void (^)(void))completionBlock {
    _completionBlock = completionBlock;
    [self configureCompletionViewController];
}

- (void)configureTimerViewController {
    // Set up the timer view to reflect our details
    if (self.timerViewController) {
        self.timerViewController.stepTitle = NSLocalizedString(@"Extra products", @"Extra products");
        [self.timerViewController hideCountdownTimer:NO];
    }
}

- (void)configureCompletionViewController {
    // Set up the completion view controller to reflect ticket tier details
    [self.completionViewController setCompletionBlock:self.completionBlock];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TXHSalesProductCell";
    TXHSalesProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.productName = @"Guide Book";
            cell.price = @(3);
            cell.quantity = @(0);
            cell.limit = @(8);
            cell.productDescription = @"A wonderful guide to your visit";
            break;
        case 1:
            cell.productName = @"Refreshments";
            cell.price = @(2);
            cell.quantity = @(5);
            cell.limit = @(9);
            cell.productDescription = @"A satisfying snack, just for you.";
            break;
        case 2:
            cell.productName = @"Day Travelcard";
            cell.price = @(8);
            cell.quantity = @(1);
            cell.limit = @(2);
            cell.productDescription = @"Now we're going places";
            break;
        case 3:
            cell.productName = @"Local Map";
            cell.price = @(3.50);
            cell.quantity = @(0);
            cell.limit = @(0);
            cell.productDescription = @"So you know where you are all the time";
            break;
        default:
            cell.productName = [NSString stringWithFormat:@"Unspecified #%d", indexPath.row - 3];
            cell.price = @(indexPath.row);
            cell.quantity = @(indexPath.row);
            cell.limit = @(8);
            cell.productDescription = @"A surprise";
            break;
    }
    
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

- (void)changeUpdateQuantity:(id)sender {
    TXHSalesProductCell *cell = sender;
    NSLog(@"updated %@ to %d", cell.productName, cell.quantity.integerValue);
}

@end
