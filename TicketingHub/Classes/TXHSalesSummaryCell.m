//
//  TXHSalesSummaryCell.m
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesSummaryCell.h"

@interface TXHSalesSummaryCell () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TXHSalesSummaryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *header = [tableView dequeueReusableCellWithIdentifier:@"SalesSummaryLineHeader"];
    header.textLabel.text = @"Ticket";
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SalesSummaryLine" forIndexPath:indexPath];
    cell.textLabel.text = @"Adult";
    cell.detailTextLabel.text = @"£8.00";
    return cell;
}

@end
