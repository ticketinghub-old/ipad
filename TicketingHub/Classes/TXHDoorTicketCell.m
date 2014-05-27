//
//  TXHDoorTicketCell.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 06/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorTicketCell.h"
#import <SevenSwitch/SevenSwitch.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImage+String.h"
#import "UIColor+TicketingHub.h"
#import "UIFont+TicketingHub.h"

@interface TXHDoorTicketCell ()

@property (weak, nonatomic) IBOutlet SevenSwitch             *attendedSwitch;
@property (weak, nonatomic) IBOutlet UILabel                 *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel                 *tierLabel;
@property (weak, nonatomic) IBOutlet UILabel                 *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel                 *pricetagLabel;
@property (weak, nonatomic) IBOutlet UIImageView             *chevronImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
    
@end

@implementation TXHDoorTicketCell

+ (NSDateFormatter *)timeFormatter
{
    static NSDateFormatter *_timeFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _timeFormatter = [[NSDateFormatter alloc] init];
        _timeFormatter.dateFormat = @" HH:mm";
    });
    
    return _timeFormatter;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.layer.cornerRadius = 10.0;
    
    self.attendedSwitch.inactiveColor  = [UIColor txhVeryLightBlueColor];
    self.attendedSwitch.onTintColor    = [UIColor txhBlueColor];
    self.attendedSwitch.borderColor    = [UIColor txhVeryLightBlueColor];
    
    [self.attendedSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (BOOL)switchValue
{
    return self.attendedSwitch.on;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (void)setTierName:(NSString *)tierName
{
    self.tierLabel.text = tierName;
}

- (void)setReference:(NSString *)orderReference
{
    self.orderLabel.text = orderReference;
}

- (void)setPrice:(NSString *)price
{
    self.pricetagLabel.text = price;
}

- (void)setAttendedAt:(NSDate *)attendedAt animated:(BOOL)animated
{
    UIImage *dateImage = nil;
    
    if (attendedAt)
    {
        NSString *dateString = [[TXHDoorTicketCell timeFormatter] stringFromDate:attendedAt];
        dateImage = [UIImage imageWithString:dateString
                                        font:[UIFont txhThinFontWithSize:16.0f]
                                       color:[UIColor whiteColor]];
        
    }
    
    [self.attendedSwitch setOn:(attendedAt != nil) animated:animated];
    self.attendedSwitch.onImage = dateImage;
}

- (void)setPriceTag:(NSString *)priceTag
{
    self.pricetagLabel.text = [priceTag length] ? priceTag : @"";
}

- (void)setIsLoading:(BOOL)loading
{
    self.attendedSwitch.enabled = !loading;

    if (loading)
        [self.activityIndicator startAnimating];
    else
        [self.activityIndicator stopAnimating];
}

- (void)switchDidChange:(id)sender
{
    [self.delegate txhDoorTicketCelldidChangeSwitch:self];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self updateView];
}

- (void)updateView
{
    BOOL highlight = self.highlighted;
    
    self.layer.borderColor = [UIColor txhBlueColor].CGColor;
    self.layer.borderWidth = highlight ? 3.0 : 0.0;
}

@end
