//
//  TXHSalesSummaryExtraProductsCell.m
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesSummaryExtraProductsCell.h"

@interface TXHSalesSummaryExtraProductsCell () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TXHSalesSummaryExtraProductsCell

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
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SalesSummaryExtraProductLine" forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Extract details from the products array
    NSDictionary *product = [self.products objectAtIndex:indexPath.row];
    NSString *description = product[@"description"];
    NSNumber *price = product[@"price"];
    NSNumber *quantity = product[@"quantity"];
    NSDictionary *attributesDict = @{NSFontAttributeName: [UIFont systemFontOfSize:12.5f]};
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%4ux%@", quantity.unsignedIntegerValue, description] attributes:attributesDict];
    [attString addAttribute: NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1, 5)];
    cell.textLabel.attributedText = attString;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"£%f", (quantity.floatValue * price.doubleValue)];
}

@end
