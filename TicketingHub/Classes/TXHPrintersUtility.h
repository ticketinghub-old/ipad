//
//  TXHPrintersUtility.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 08/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXHPrinter.h"

typedef NS_ENUM(NSUInteger, TXHPrintType)
{
    TXHPrintTypeTemplates,
    TXHPrintTypeTickets,
    TXHPrintTypeRecipt,
    TXHPrintTypeSummary
};

@class TXHPrintersUtility;

@protocol TXHPrintersUtilityDelegate <NSObject>

- (void)txhPrintersUtility:(TXHPrintersUtility *)utility didStartLoadingType:(TXHPrintType)type;
- (void)txhPrintersUtility:(TXHPrintersUtility *)utility didFinishLoadingType:(TXHPrintType)type error:(NSError *)error;

- (void)txhPrintersUtility:(TXHPrintersUtility *)utility didStartPrintingType:(TXHPrintType)type;
- (void)txhPrintersUtility:(TXHPrintersUtility *)utility didFinishPrintingType:(TXHPrintType)type error:(NSError *)error;

// TODO: maybe there is a better way
- (void)txhPrintersUtility:(TXHPrintersUtility *)utility selectTicketTemplate:(void(^)(TXHTicketTemplate *))selectTemplate fromTemplates:(NSArray *)templates;

- (TXHPrinterContinueBlock)txhPrintersUtilityContinuePrintingBlock:(TXHPrintersUtility *)utility;


@end

@interface TXHPrintersUtility : NSObject

@property (weak, nonatomic) id<TXHPrintersUtilityDelegate> delegate;

- (instancetype)initWithTicketingHubCLient:(TXHTicketingHubClient *)client;

- (void)startPrintingWithType:(TXHPrintType)type onPrinter:(TXHPrinter *)printer withOrder:(TXHOrder *)order;
- (void)startPrintingWithType:(TXHPrintType)type onPrinter:(TXHPrinter *)printer withTicket:(TXHTicket *)ticket;
- (void)startPrintingWithType:(TXHPrintType)type onPrinter:(TXHPrinter *)printer withUser:(TXHUser *)user;

@end
