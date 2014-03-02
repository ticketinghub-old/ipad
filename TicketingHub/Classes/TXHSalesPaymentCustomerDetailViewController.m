//
//  TXHSalesPaymentCustomerDetailViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentCustomerDetailViewController.h"

#import "TXHDataSelectionView.h"
#import "TXHSelectionEntryTableViewCell.h"
#import "TXHTextEntryTableViewCell.h"

static NSString * const kUserInfoPlaceholderKey = @"kUserInfoPlaceholderKey";
static NSString * const kUserInfoLabelKey       = @"kUserInfoLabelKey";
static NSString * const kUserInfoTypeKey        = @"kUserInfoTypeKey";
static NSString * const kUserInfoValueKey       = @"kUserInfoValueKey";
static NSString * const kUserInfoValuesArrayKey = @"kUserInfoValuesArrayKey";
static NSString * const kUserInfoErrorKey       = @"kUserInfoErrorKey";

@interface TXHSalesPaymentCustomerDetailViewController ()

@property (strong, nonatomic) NSArray *userInfo;
@property (weak, nonatomic) IBOutlet UILabel *detailsTitle;

@end

@implementation TXHSalesPaymentCustomerDetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userInfo = @[
                      @{kUserInfoPlaceholderKey : @"First Name",
                        kUserInfoTypeKey : @"text"}.mutableCopy,
                      
                      @{kUserInfoPlaceholderKey : @"Last Name",
                        kUserInfoTypeKey : @"text"}.mutableCopy,
                      
                      @{kUserInfoPlaceholderKey : @"Email Address",
                        kUserInfoTypeKey : @"text"}.mutableCopy,
                      
                      @{kUserInfoPlaceholderKey : @"Telephone",
                        kUserInfoTypeKey : @"text"}.mutableCopy,
                      
                      @{kUserInfoPlaceholderKey : @"Country",
                        kUserInfoValuesArrayKey : @[@"United Kingdom", @"Poland"],
                        kUserInfoTypeKey : @"select"}.mutableCopy,
                      ];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellInfo = self.userInfo[indexPath.row];

    UITableViewCell *cell;
    
    if ([cellInfo[kUserInfoTypeKey] isEqualToString:@"text"])
    {
        TXHTextEntryTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"TXHSalesPaymentCustomerDetailsTextCell" forIndexPath:indexPath];
        
        textCell.text         = cellInfo[kUserInfoValueKey];
        textCell.placeholder  = cellInfo[kUserInfoPlaceholderKey];
        textCell.errorMessage = cellInfo[kUserInfoErrorKey];
        
        cell = textCell;
    }
    else if ([cellInfo[kUserInfoTypeKey] isEqualToString:@"select"])
    {
        TXHSelectionEntryTableViewCell *selectionCell = [tableView dequeueReusableCellWithIdentifier:@"TXHSalesPaymentCustomerDetailsSelectionCell" forIndexPath:indexPath];
        
        selectionCell.placeholder  = cellInfo[kUserInfoPlaceholderKey];
        selectionCell.value        = cellInfo[kUserInfoValueKey];
        selectionCell.errorMessage = cellInfo[kUserInfoErrorKey];
        selectionCell.options      = cellInfo[kUserInfoValuesArrayKey];
        
        cell = selectionCell;
    }
    
    return cell;
}

@end
