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
#import "TXHUserMO.h"
#import "TXHVenueMO.h"

@interface TXHMenuController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *logoutView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSArray *venues;

@end

@implementation TXHMenuController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *backgroundColor = [UIColor colorWithRed:16.0f / 255.0f
                                               green:46.0f / 255.0f
                                                blue:66.0f / 255.0f
                                               alpha:1.0f];

    self.view.backgroundColor = backgroundColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [self.logoutButton setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Logout", @"Logout the current user"), [self userName]] forState:UIControlStateNormal];

    self.venues = [TXHServerAccessManager sharedInstance].venues;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSUInteger venueCount = [TXHServerAccessManager sharedInstance].venues.count;
    return venueCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    TXHVenue *venue = [self.venues objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VENUE_SELECTED object:venue];
}

#pragma mark - Private methods

- (NSString *)userName {
    NSFetchRequest *userRequest = [NSFetchRequest fetchRequestWithEntityName:[TXHUserMO entityName]];

    NSError *error;
    NSArray *users = [self.managedObjectContext executeFetchRequest:userRequest error:&error];

    if (!users) {
        DLog(@"Unable to fetch users because: %@", error);
    }

    TXHUserMO *user = [users lastObject];

    return [user fullName];

}

#pragma mark Action methods

- (IBAction)logout:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MENU_LOGOUT object:nil];
    self.logoutButton.titleLabel.text = NSLocalizedString(@"Logout", @"Logout the current user");
}


@end
