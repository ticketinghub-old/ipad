//
//  TXHActivityLabelPrintersUtilityDelegate.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 08/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHActivityLabelPrintersUtilityDelegate.h"
#import "TXHActivityLabelView.h"
#import "NSError+TXHPrinters.h"
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>


@implementation TXHActivityLabelPrintersUtilityDelegate

#pragma mark - TXHPrintersUtilityDelegate

- (void)txhPrintersUtility:(TXHPrintersUtility *)utility didStartLoadingType:(TXHPrintType)type
{
    [self.activityView showWithMessage:[self loadingTextForPrintType:type]
                       indicatorHidden:NO];
}

- (void)txhPrintersUtility:(TXHPrintersUtility *)utility didFinishLoadingType:(TXHPrintType)type error:(NSError *)error
{
    [self finishPrintingWithError:error];
}

- (void)txhPrintersUtility:(TXHPrintersUtility *)utility didStartPrintingType:(TXHPrintType)type
{
    [self.activityView showWithMessage:[self printingTextForPrintType:type]
                       indicatorHidden:NO];
}

- (void)txhPrintersUtility:(TXHPrintersUtility *)utility didFinishPrintingType:(TXHPrintType)type error:(NSError *)error
{
    [self finishPrintingWithError:error];
}

- (void)finishPrintingWithError:(NSError *)error
{
    [self.activityView hide];
    
    if (error)
    {
        [[[UIAlertView alloc] initWithTitle:[self titleForError:error]
                                   message:error.localizedDescription
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"ERROR_DISMISS_BUTTON_TITLE", nil)
                         otherButtonTitles:nil] show];
    }
}

- (NSString *)titleForError:(NSError *)error
{
    if ([error.domain isEqualToString:TXHPrinterErrorDomain])
        return NSLocalizedString(@"PRINTER_ERROR_TITLE", nil);
    
    return NSLocalizedString(@"ERROR_TITLE", nil);
}

- (void)txhPrintersUtility:(TXHPrintersUtility *)utility selectTicketTemplate:(void(^)(TXHTicketTemplate *))selectTemplate fromTemplates:(NSArray *)templates
{
    [self.activityView showWithMessage:@"" indicatorHidden:YES];
    
    __weak typeof(self) wself = self;
    
    RIButtonItem *cancelButton = [RIButtonItem itemWithLabel:NSLocalizedString(@"TICKET_TEMPLATES_SELECTION_CANCEL_BUTTON_TITLE", nil)
                                                      action:^{[wself.activityView hide];}];
    
    UIAlertView *templatesAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TICKET_TEMPLATES_SELECTION_TITLE", nil)
                                                             message:nil
                                                    cancelButtonItem:cancelButton
                                                    otherButtonItems:nil];
    
    for (TXHTicketTemplate *template in templates)
    {
        RIButtonItem *item = [RIButtonItem itemWithLabel:template.name
                                                  action:^{selectTemplate(template);}];
        [templatesAlert addButtonItem:item];
    }
    
    [templatesAlert show];
}

- (NSString *)loadingTextForPrintType:(TXHPrintType)printType
{
    switch (printType) {
        case TXHPrintTypeTemplates:
            return NSLocalizedString(@"LOADING_TICKETS_TEMPLATES_LABEL", nil);
        case TXHPrintTypeTickets:
            return NSLocalizedString(@"LOADING_TICKETS_LABEL", nil);
        case TXHPrintTypeRecipt:
            return NSLocalizedString(@"LOADING_RECEIPT_LABEL", nil);
    }
    return @"";
}

- (NSString *)printingTextForPrintType:(TXHPrintType)printType
{
    switch (printType) {
        case TXHPrintTypeTemplates:
            return @"";
        case TXHPrintTypeTickets:
            return NSLocalizedString(@"PRINTING_TICKETS_LABEL", nil);
        case TXHPrintTypeRecipt:
            return NSLocalizedString(@"PRINTING_RECEIPT_LABEL", nil);
    }
    return @"";
}

- (TXHPrinterContinueBlock)txhPrintersUtilityContinuePrintingBlock:(TXHPrintersUtility *)utility
{
    return ^(void (^continuePrinting)(BOOL shallContinue, BOOL printALl))
    {
        RIButtonItem *allButton = [RIButtonItem itemWithLabel:NSLocalizedString(@"CONTINUE_PRINTING_ALL_BUTTON_TITLE", nil)
                                                       action:^{ continuePrinting(YES, YES); }];
        
        RIButtonItem *nextButton = [RIButtonItem itemWithLabel:NSLocalizedString(@"CONTINUE_PRINTING_NEXT_BUTTON_TITLE", nil)
                                                        action:^{ continuePrinting(YES, NO); }];
        
        RIButtonItem *stopButton = [RIButtonItem itemWithLabel:NSLocalizedString(@"CONTINUE_PRINTING_STOP_BUTTON_TITLE", nil)
                                                        action:^{ continuePrinting(NO, NO); }];
        
        UIAlertView *continueAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CONTINUE_PRINTING_TITLE", nil)
                                                                message:nil
                                                       cancelButtonItem:nil
                                                       otherButtonItems:stopButton, allButton, nextButton, nil];
        [continueAlert show];
    };
}


@end
