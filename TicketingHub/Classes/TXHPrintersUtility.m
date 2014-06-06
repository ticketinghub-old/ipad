//
//  TXHPrintersUtility.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 08/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPrintersUtility.h"

#import "TXHTicketingHubManager.h"
#import "TXHPrintersManager.h"

@interface TXHPrintersUtility ()

@property (assign, nonatomic) TXHPrintType        printType;
@property (strong, nonatomic) TXHPrinter          *selectedPrinter;
@property (strong, nonatomic) UIPopoverController *printerSelectorPopover;

@property (strong, nonatomic) TXHOrder              *order;
@property (strong, nonatomic) TXHTicket             *ticket;
@property (strong, nonatomic) TXHTicketingHubClient *client;

@end

@implementation TXHPrintersUtility

- (instancetype)initWithTicketingHubCLient:(TXHTicketingHubClient *)client
{
    if (!(self = [super init]))
        return nil;
    
    self.client = client;
    
    return self;
}

- (void)setSelectedPrinter:(TXHPrinter *)selectedPrinter
{
    _selectedPrinter = selectedPrinter;
    
    if (!selectedPrinter.hasCutter)
    {
        TXHPrinterContinueBlock continueBlock = [self.delegate txhPrintersUtilityContinuePrintingBlock:self];
        [_selectedPrinter setPrintingContinueBlock:continueBlock];
    }
}

- (void)startPrintingWithType:(TXHPrintType)type onPrinter:(TXHPrinter *)printer withOrder:(TXHOrder *)order
{
    self.order           = order;
    self.ticket          = nil;
    self.printType       = type;
    self.selectedPrinter = printer;
    
    [self printSelectedTarget];
}

- (void)startPrintingWithType:(TXHPrintType)type onPrinter:(TXHPrinter *)printer withTicket:(TXHTicket *)ticket
{
    self.ticket          = ticket;
    self.order           = nil;
    self.printType       = type;
    self.selectedPrinter = printer;
    [self printSelectedTarget];
}

- (void)printSelectedTarget
{
    switch (self.printType)
    {
        case TXHPrintTypeRecipt:
            [self getAndPrintReceipt];
            break;
        case TXHPrintTypeTickets:
            [self getAndPrintTickets];
            break;
        case TXHPrintTypeTemplates:
            break;
    }
}

- (void)getAndPrintReceipt
{
    [self.delegate txhPrintersUtility:self didStartLoadingType:TXHPrintTypeRecipt];
    
    __weak typeof(self) wself = self;
    
    [self.client getReciptForOrder:self.order
                            format:TXHDocumentFormatPDF
                             width:self.selectedPrinter.paperWidth
                               dpi:self.selectedPrinter.dpi
                        completion:^(NSURL *url, NSError *error) {
                            
                            [wself.delegate txhPrintersUtility:wself didFinishLoadingType:TXHPrintTypeRecipt error:error];
                            
                            if (!error)
                                [wself printPDFDocumentWithURL:url];
                        }];
}

- (void)getAndPrintTickets
{
    [self.delegate txhPrintersUtility:self didStartLoadingType:TXHPrintTypeTickets];
    
    __weak typeof(self) wself = self;
    
    [self.client getTicketTemplatesCompletion:^(NSArray *templates, NSError *error) {
        
        [wself.delegate txhPrintersUtility:wself didFinishLoadingType:TXHPrintTypeTickets error:error];
        
        if (!error)
            [wself selectTemplateFromTemplates:templates];
    }];
}

- (void)selectTemplateFromTemplates:(NSArray *)templates
{
    __weak typeof(self) wself = self;
    
    [self.delegate txhPrintersUtility:self
                 selectTicketTemplate:
                    ^(TXHTicketTemplate *selectedTemplate) {
                        if (wself.order)
                            [wself printTicketsWithTemplate:selectedTemplate];
                        if (wself.ticket)
                            [wself printTicketWithTemplate:selectedTemplate];
                    }
                        fromTemplates:templates];
}

- (void)printPDFDocumentWithURL:(NSURL *)fileURL
{
    [self.delegate txhPrintersUtility:self didStartPrintingType:self.printType];
    
    __weak typeof(self) wself = self;
    
    [self.selectedPrinter printPDFDocumentWithURL:fileURL completion:^(NSError *error, BOOL canceled){
        [wself.delegate txhPrintersUtility:wself didFinishPrintingType:wself.printType error:error];
    }];
}

- (void)printTicketsWithTemplate:(TXHTicketTemplate *)template
{
    if (!template) return;
    
    __weak typeof(self) wself = self;
    
    __block NSError * printingError = nil;
    
    void (^ticketCompletion)(NSError *error, BOOL canceled) = ^(NSError *error, BOOL canceled) {
        if (error) printingError = error;
        [wself.delegate txhPrintersUtility:wself didFinishPrintingType:wself.printType error:error];
    };
    
    for (TXHTicket * ticket in self.order.tickets) {
        if (printingError) break;
        [self.delegate txhPrintersUtility:self didStartLoadingType:TXHPrintTypeTemplates];
        [self.client getTicketImageToPrintForTicket:ticket withTemplet:template format:TXHDocumentFormatPNG completion:^(UIImage *image, NSError *err) {
            [wself.delegate txhPrintersUtility:self didFinishLoadingType:TXHPrintTypeTemplates error:nil];
            [wself.delegate txhPrintersUtility:self didStartPrintingType:wself.printType];
                [wself.selectedPrinter printImage:image completion:ticketCompletion];
        }];
    }
}

- (void)printTicketWithTemplate:(TXHTicketTemplate *)template
{
    __weak typeof(self) wself = self;
    [self.client getTicketImageToPrintForTicket:self.ticket withTemplet:template format:TXHDocumentFormatPNG completion:^(UIImage *image, NSError *err) {
        [wself.selectedPrinter printImage:image completion:^(NSError *error, BOOL canceled) {
            [wself.delegate txhPrintersUtility:wself didFinishPrintingType:wself.printType error:error];
        }];
    }];
}

@end
