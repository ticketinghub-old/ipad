//
//  TXHTicketDetailsErrorView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 17/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHTicketDetailsErrorView.h"

#import "NSDateFormatter+DisplayFormat.h"

#import "UIFont+TicketingHub.h"


@interface TXHTicketDetailsErrorView ()

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation TXHTicketDetailsErrorView

- (void)showWithError:(TXHTicketDetailsErrorType)errorType date:(NSDate *)date
{
    switch (errorType) {
        case TXHTicketDetailsEarlyError:
        {
            [self setError:NSLocalizedString(@"TICKET_DETAILS_EARLY_ERROR_MESSAGE", nil) boldPart:nil];
        }
            break;
        
        case TXHTicketDetailsExpiredError:
        {
            [self setError:NSLocalizedString(@"TICKET_DETAILS_EXPIRED_ERROR_MESSAGE", nil) boldPart:nil];
        }
            break;
            
        case TXHTicketDetailsCancelledError:
        {
            [self showWithCancellationDate:date];
        }
            break;
    }
}

- (void)showWithCancellationDate:(NSDate *)expirationDate
{
    NSString *dateString    = [NSDateFormatter txh_fullDateStringFromDate:expirationDate];
    NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"TICKET_DETAILS_ERROR_MESSAGE_FORMAT", nil), dateString];
    
    [self setError:messageString boldPart:dateString];
}

- (void)setError:(NSString *)errorMessage boldPart:(NSString *)boldString
{
    NSMutableAttributedString *errorMessageAttributed = [[NSMutableAttributedString alloc] initWithString:errorMessage];
    
    if ([boldString length])
    {
        NSRange boldRange = [errorMessage rangeOfString:boldString];
        
        [errorMessageAttributed addAttribute:NSFontAttributeName
                                       value:[UIFont txhBoldFontWithSize:self.errorLabel.font.pointSize]
                                       range:boldRange];
    }
    self.errorLabel.attributedText = errorMessageAttributed;
}

- (void)hide
{
    self.hidden = YES;
}

@end
