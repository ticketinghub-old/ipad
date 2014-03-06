//
//  TXHDoorTicketCell.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 06/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHDoorTicketCell.h"
#import <SevenSwitch/SevenSwitch.h>
#import "UIImage+String.h"
#import "UIColor+TicketingHub.h"

@interface TXHDoorTicketCell ()

@property (weak, nonatomic) IBOutlet SevenSwitch        *attendedSwitch;
@property (weak, nonatomic) IBOutlet UILabel            *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel            *secondaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *chevronImageView;
@property (weak, nonatomic) IBOutlet UIView             *topSeparatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSeparatorLeadingConstraint;

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
    
    UIImage *chervon = [self.chevronImageView image];
    chervon = [chervon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.chevronImageView.image = chervon;

    self.attendedSwitch.inactiveColor  = [UIColor whiteColor];
    self.attendedSwitch.onTintColor    = [UIColor colorFromHexString:@"#18a651" alpha:1.0];
    self.attendedSwitch.borderColor    = [UIColor colorFromHexString:@"#dce5ec" alpha:1.0];
}

- (void)setIsFirstRow:(BOOL)isFirst
{
    self.topSeparatorView.hidden = !isFirst;
}

- (void)setIsLastRow:(BOOL)isLast
{
    self.bottomSeparatorLeadingConstraint.constant = isLast ? 0 : self.mainLabel.frame.origin.x;
}

- (void)setTitle:(NSString *)title
{
    self.mainLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.secondaryLabel.text = subtitle;
}

- (void)setAttendedAt:(NSDate *)attendedAt
{
    UIImage *dateImage = nil;
    
    if (attendedAt)
    {
        NSString *dateString = [[TXHDoorTicketCell timeFormatter] stringFromDate:attendedAt];
        dateImage = [UIImage imageWithString:dateString
                                        font:[UIFont fontWithName:@"Helvetica" size:14]
                                       color:[UIColor whiteColor]];
        
        self.attendedSwitch.on = YES;
    }
    
    self.attendedSwitch.onImage = dateImage;
}

@end
