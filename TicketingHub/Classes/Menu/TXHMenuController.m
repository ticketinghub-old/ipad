//
//  TXHMenuController.m
//  TicketingHub
//
//  Created by Mark on 10/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMenuController.h"

#import "TXHCommonNames.h"
#import "TXHServerAccessManager.h"
#import "TXHVenue.h"

@interface TXHMenuController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *logoutView;
@property (weak, nonatomic) IBOutlet UIButton *logout;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSArray *venues;

@end

@implementation TXHMenuController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuLogin:) name:NOTIFICATION_MENU_LOGIN object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *backgroundColor = [UIColor colorWithRed:16.0f / 255.0f
                                               green:46.0f / 255.0f
                                                blue:66.0f / 255.0f
                                               alpha:1.0f];
    
    self.view.backgroundColor = backgroundColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.venues = [TXHServerAccessManager sharedInstance].venues;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
    NSUInteger venueCount = [TXHServerAccessManager sharedInstance].venues.count;
    return venueCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
#pragma unused (tableView)
#pragma unused (section)
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    TXHVenue *venue = [self.venues objectAtIndex:indexPath.row];
#warning - AN turned this off!
//    cell.textLabel.text = venue.businessName;
    cell.textLabel.text = @"Blame AN";

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
#pragma unused (section)
    if (self.headerView == nil) {
        CGRect frame = tableView.bounds;
        frame.size.height = 64.0f;
        self.headerView = [[UIView alloc] initWithFrame:frame];
        self.headerView.backgroundColor = self.view.backgroundColor;
        NSString *titleString = @"Venues";
        UIFont *font = [UIFont systemFontOfSize:34.0f];
        NSDictionary *attributesDict = @{NSFontAttributeName : font};
        NSAttributedString *attributedTitleString = [[NSAttributedString alloc] initWithString:titleString attributes:attributesDict];
        CGSize titleSize = [attributedTitleString size];
        
        CGRect titleLabelFrame = CGRectZero;
        titleLabelFrame.origin.x = 17.50f;
        titleLabelFrame.origin.y = self.headerView.bounds.size.height - titleSize.height;
        titleLabelFrame.size = titleSize;
        
        UILabel *title = [[UILabel alloc] initWithFrame:titleLabelFrame];
        title.backgroundColor = self.headerView.backgroundColor;
        title.textColor = [UIColor whiteColor];
        title.font = font;
        title.text = titleString;
        [self.headerView addSubview:title];
    }
    return self.headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma unused (tableView)
    TXHVenue *venue = [self.venues objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VENUE_SELECTED object:venue];
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

- (IBAction)logout:(id)sender {
#pragma unused (sender)
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MENU_LOGOUT object:nil];
    self.logout.titleLabel.text = NSLocalizedString(@"Logout", @"Logout the current user");
}

#pragma mark - Notifications

- (void)menuLogin:(NSNotification *)notification {
    // Logged in user will be supplied as a string in the notification object
    NSString *user = notification.object;
    
    [self.logout setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Logout", @"Logout the current user"), user] forState:UIControlStateNormal];
}

@end
