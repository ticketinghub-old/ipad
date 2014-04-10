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

@property (strong, nonatomic) TXHOrder            *order;

@end

@implementation TXHPrintersUtility


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
    
    [TXHTICKETINHGUBCLIENT getReciptForOrder:self.order
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
    
    [TXHTICKETINHGUBCLIENT getTicketTemplatesCompletion:^(NSArray *templates, NSError *error) {
        
        [wself.delegate txhPrintersUtility:wself didFinishLoadingType:TXHPrintTypeTickets error:error];
        
        if (!error)
            [wself selectTemplateFromTemplates:templates];
    }];
}

- (void)selectTemplateFromTemplates:(NSArray *)templates
{
    __weak typeof(self) wself = self;

    [self.delegate txhPrintersUtility:self
                 selectTicketTemplate:^(TXHTicketTemplate *selectedTemplate) { [wself printTicketsWithTemplate:selectedTemplate]; }
                        fromTemplates:templates];
}

- (void)printPDFDocumentWithURL:(NSURL *)fileURL
{
    [self.delegate txhPrintersUtility:self didStartPrintingType:self.printType];
    
    __weak typeof(self) wself = self;
    
    [self.selectedPrinter printPDFDocument:fileURL completion:^(NSError *error, BOOL canceled){
        [wself.delegate txhPrintersUtility:wself didFinishPrintingType:wself.printType error:error];
    }];
}

- (void)printTicketsWithTemplate:(TXHTicketTemplate *)template
{
    if (!template) return;
    
    [self.delegate txhPrintersUtility:self didStartLoadingType:TXHPrintTypeTemplates];
    
    __weak typeof(self) wself = self;
    
    [TXHTICKETINHGUBCLIENT getTicketToPrintForOrder:self.order
                                        withTemplet:template
                                             format:TXHDocumentFormatPDF
                                         completion:^(NSURL *url, NSError *error){
                                             
                                             [wself.delegate txhPrintersUtility:wself didFinishLoadingType:TXHPrintTypeTemplates error:error];
                                             
                                             if (!error)
                                                 [wself printPDFDocumentWithURL:url];
                                         }];
}

@end
