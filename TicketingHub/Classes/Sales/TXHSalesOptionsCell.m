//
//  TXHSalesOptionsCell.m
//  TicketingHub
//
//  Created by Mark on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesOptionsCell.h"
#import "TXHOptionsExtrasItem.h"

@interface TXHSalesOptionsCell ()

@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@end

@implementation TXHSalesOptionsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOptionItem:(TXHOptionsExtrasItem *)optionItem {
  _optionItem = optionItem;
  self.description.text = _optionItem.description;
  self.quantity.text = _optionItem.quantity.stringValue;
  self.price.text = _optionItem.formattedPrice;
}

@end
