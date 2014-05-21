//
//  TXHTicketDetailsErrorView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 17/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHTicketDetailsErrorView.h"
#import "NSDate+Additions.h"

@interface TXHTicketDetailsErrorView ()

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation TXHTicketDetailsErrorView

- (void)showWithExpirationDate:(NSDate *)expirationDate
{
    BOOL ticketExpired = [expirationDate isInThePast];
    
    self.hidden = !ticketExpired;
    
    NSString *errorConstant = [self errorMessageConstant];
    NSString *errorDurationMesage = nil;
    
    if (ticketExpired)
    {
        NSInteger daysFromNow = [expirationDate daysFromNow];
        if (daysFromNow > 0)
        {
            errorDurationMesage = [self errorForDays:daysFromNow];
        }
        else
        {
            NSInteger hoursFromNow = [expirationDate hoursFromNow];
            if (hoursFromNow > 0)
            {
                errorDurationMesage = [self errorForHours:hoursFromNow];
            }
            else
            {
                NSInteger minutesFromNow = [expirationDate minutesFromNow];
                errorDurationMesage = [self errorForMinutes:minutesFromNow];
            }
            
        }
        [self setErrorMessageBold:errorDurationMesage normalString:errorConstant];
    }
}

- (void)hide
{
    self.hidden = YES;
}

- (void)setErrorMessageBold:(NSString *)boldString normalString:(NSString *)normalString
{
    NSString *error = [NSString stringWithFormat:@"%@ %@",boldString, normalString];
    NSRange boldRange = [error rangeOfString:boldString];
    
    NSMutableAttributedString *errorMessage = [[NSMutableAttributedString alloc] initWithString:error];
    [errorMessage addAttribute:NSFontAttributeName
                         value:[UIFont boldSystemFontOfSize:15]
                         range:boldRange];
    
    self.errorLabel.attributedText = errorMessage;
}

- (NSString *)errorForMinutes:(NSInteger)minutes
{
    return [NSString stringWithFormat:@"This Ticket expired %ld minutes ago.",(long)minutes];
}

- (NSString *)errorForHours:(NSInteger)hours
{
    return [NSString stringWithFormat:@"This Ticket expired %ld hours ago.",(long)hours];
}

- (NSString *)errorForDays:(NSInteger)days
{
    return [NSString stringWithFormat:@"This Ticket expired %ld days ago.", (long)days];
}

- (NSString *)errorMessageConstant
{
    return @"You still have option to grant access.";
}

@end
