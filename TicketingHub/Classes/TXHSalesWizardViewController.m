//
//  TXHSalesWizardViewController.m
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesWizardViewController.h"

#import "TXHSalesStep.h"
#import "TXHSalesWizardTabelViewCell.h"

@interface TXHSalesWizardViewController ()

@end

@implementation TXHSalesWizardViewController

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(salesWizardViewController:canSelectStepAtIndex:)])
        return [self.dataSource salesWizardViewController:self canSelectStepAtIndex:indexPath.row];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataSource salesWizardViewController:self didSelectStepAtIndex:indexPath.row];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.dataSource numberOfsteps];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXHSalesWizardTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SalesWizardTabelViewCell"
                                                            forIndexPath:indexPath];
    
    TXHSalesStep *item = [self.dataSource stepAtIndex:indexPath.row];
    [self configureCell:cell withStep:item];
    
    return cell;
}

- (void)configureCell:(TXHSalesWizardTabelViewCell *)cell withStep:(TXHSalesStep *)step
{
    [cell setTite:step.title];
    [cell setDetails:step.description];
    [cell setNumber:[self.dataSource indexOfStep:step]+1];
    [cell setCompleted:[self.dataSource isStepCompleted:step]];
    [cell setIsCurrent:[self.dataSource isStepCurrent:step]];
}

#pragma mark - Public methods

- (void)reloadWizard
{
    [self.tableView reloadData];
}

@end
