//
//  DKPOSClientTransactionInfo+Messages.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 23/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "DKPOSClientTransactionInfo+Messages.h"

@implementation DKPOSClientTransactionInfo (Messages)

- (NSString *)titleText
{
    switch (self.statusCode)
    {
        case DKPOSClientTransactionStatusCodeWaitingForCard:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeWaitingForCard",nil);
        case DKPOSClientTransactionStatusCodeCardInserted:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeCardInserted",nil);
        case DKPOSClientTransactionStatusSignatureRequested:
            return NSLocalizedString(@"DKPOSClientTransactionStatusSignatureRequested",nil);
        case DKPOSClientTransactionStatusCodeApplicationSelection:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeApplicationSelection",nil);
        case DKPOSClientTransactionStatusCodeApplicationConfirmation:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeAmountValidation",nil);
        case DKPOSClientTransactionStatusCodeAmountValidation:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodePinInput",nil);
        case DKPOSClientTransactionStatusCodePinInput:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodePinInput",nil);
        case DKPOSClientTransactionStatusCodeManualCardInput:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeManualCardInput",nil);
        case DKPOSClientTransactionStatusCodeWaitingCardRemoval:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeWaitingCardRemoval",nil);
        case DKPOSClientTransactionStatusCodeTipInput:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeTipInput",nil);
        case DKPOSClientTransactionStatusCodeConnecting:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeConnecting",nil);
        case DKPOSClientTransactionStatusCodeSending:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeSending",nil);
        case DKPOSClientTransactionStatusCodeReceiving:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeReceiving",nil);
        case DKPOSClientTransactionStatusCodeDisconnecting:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeDisconnecting",nil);
        case DKPOSClientTransactionStatusCodeTransactionApproved:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeTransactionApproved",nil);
        case DKPOSClientTransactionStatusCodeTransactionProcessed:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeTransactionProcessed",nil);
    }
    return nil;
}

- (NSString *)descriptionText
{
    switch (self.statusCode)
    {
        case DKPOSClientTransactionStatusCodeWaitingForCard:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeWaitingForCardDesc",nil);
        case DKPOSClientTransactionStatusCodeCardInserted:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeCardInsertedDesc",nil);
        case DKPOSClientTransactionStatusSignatureRequested:
            return NSLocalizedString(@"DKPOSClientTransactionStatusSignatureRequestedDesc",nil);
        case DKPOSClientTransactionStatusCodeApplicationSelection:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeApplicationSelectionDesc",nil);
        case DKPOSClientTransactionStatusCodeApplicationConfirmation:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeAmountValidationDesc",nil);
        case DKPOSClientTransactionStatusCodeAmountValidation:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodePinInputDesc",nil);
        case DKPOSClientTransactionStatusCodePinInput:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodePinInputDesc",nil);
        case DKPOSClientTransactionStatusCodeManualCardInput:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeManualCardInputDesc",nil);
        case DKPOSClientTransactionStatusCodeWaitingCardRemoval:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeWaitingCardRemovalDesc",nil);
        case DKPOSClientTransactionStatusCodeTipInput:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeTipInputDesc",nil);
        case DKPOSClientTransactionStatusCodeConnecting:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeConnectingDesc",nil);
        case DKPOSClientTransactionStatusCodeSending:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeSendingDesc",nil);
        case DKPOSClientTransactionStatusCodeReceiving:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeReceivingDesc",nil);
        case DKPOSClientTransactionStatusCodeDisconnecting:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeDisconnectingDesc",nil);
        case DKPOSClientTransactionStatusCodeTransactionApproved:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeTransactionApprovedDesc",nil);
        case DKPOSClientTransactionStatusCodeTransactionProcessed:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeTransactionProcessedDesc",nil);
    }
    return nil;
}

- (UIImage *)iconImage
{
    switch (self.statusCode)
    {
        case DKPOSClientTransactionStatusCodeWaitingForCard:
            return [UIImage imageNamed:@"Insert_Card_Icon"];
            
        case DKPOSClientTransactionStatusCodeCardInserted:
            return [UIImage imageNamed:@"Connected_Icon"];
            
        case DKPOSClientTransactionStatusSignatureRequested:
            return [UIImage imageNamed:@"Connected_Icon"];
            
        case DKPOSClientTransactionStatusCodeApplicationSelection:
            return [UIImage imageNamed:@"Connected_Icon"];
            
        case DKPOSClientTransactionStatusCodeApplicationConfirmation:
            return [UIImage imageNamed:@"Connected_Icon"];
            
        case DKPOSClientTransactionStatusCodeAmountValidation:
            return [UIImage imageNamed:@"Connected_Icon"];
            
        case DKPOSClientTransactionStatusCodePinInput:
            return [UIImage imageNamed:@"Pin_Icon"];
            
        case DKPOSClientTransactionStatusCodeManualCardInput:
            return [UIImage imageNamed:@"Connected_Icon"];
            
        case DKPOSClientTransactionStatusCodeWaitingCardRemoval:
            return [UIImage imageNamed:@"Remove_Card_Icon"];
            
        case DKPOSClientTransactionStatusCodeTipInput:
            return [UIImage imageNamed:@"Connected_Icon"];
            
        case DKPOSClientTransactionStatusCodeConnecting:
            return [UIImage imageNamed:@"Connected_Icon"];
            
        case DKPOSClientTransactionStatusCodeSending:
            return [UIImage imageNamed:@"Connected_Icon"];
            
        case DKPOSClientTransactionStatusCodeReceiving:
            return [UIImage imageNamed:@"Connected_Icon"];
            
        case DKPOSClientTransactionStatusCodeDisconnecting:
            return [UIImage imageNamed:@"Connected_Icon"];
            
        case DKPOSClientTransactionStatusCodeTransactionApproved:
            return [UIImage imageNamed:@"Connected_Icon"];
            
        case DKPOSClientTransactionStatusCodeTransactionProcessed:
            return [UIImage imageNamed:@"Connected_Icon"];
    }
    return nil;
    return [UIImage imageNamed:@""];
}

@end
