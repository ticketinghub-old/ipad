
//
//  TXHStarIOPrintersEngine.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHStarIOPrintersEngine.h"
#import "TXHStarIOPrinter.h"


#import "NSError+TXHPrinters.h"
#import <UIImage+PDF/UIImage+PDF.h>
#import "UIImage+ImageEffects.h"

#import "RasterDocument.h"
#import "StarBitmap.h"
#import <sys/time.h>
#import <unistd.h>

static char * const POS_OPEN_DRAWER_COMMAND = "\x07";

static NSString * const kPrinterPortSettingsPortable    = @"mini";
static NSString * const kPrinterPortSettingsPOS         = @"";

#define STAR_PRINTER_MAXWIDTH                           576

@implementation TXHStarIOPrintersEngine

#pragma mark - TXHPrintersEngineProtocol

- (void)fetchAvailablePrinters:(void(^)(NSArray *printers, NSError *error))completion
{
    if (!completion) return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *printers = [SMPort searchPrinter:@"BT:"];
        NSMutableArray *starPrinters = @[].mutableCopy;
        
        for (PortInfo *portInfo in printers)
        {
            TXHStarIOPrinter *printer = [[TXHStarIOPrinter alloc] initWithPrintersEngine:self andPortInfo:portInfo];
            [starPrinters addObject:printer];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([starPrinters copy], nil);
        });
    });
}

/**
 
 
 
 */
- (void)printPDFDocument:(id)documentURL
             withPrinter:(TXHPrinter *)printer
           continueBlock:(TXHPrinterContinueBlock)continueBlock
         completionBlock:(TXHPrinterCompletionBlock)completionBlock
{
    if (!printer)
    {
        if (completionBlock)
            completionBlock([NSError printerErrorWithCode:kTXHPrinterArgsInconsistencyError],YES);

        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)documentURL);
        size_t pageCount = CGPDFDocumentGetNumberOfPages(pdf);
        
        __block BOOL printAllPages = (continueBlock == nil);
        
        for (int page = 0; page < pageCount; page++)
        {
            __block BOOL printNextPage = YES;
            
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

            void(^askToContinueBlock)(NSError *error) =

            ^(NSError *error) {
                
                if (!printAllPages && page + 1 < pageCount)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        continueBlock(^(BOOL continuePrinting, BOOL printAll)
                                      {
                                          printAllPages = printAll;
                                          printNextPage = continuePrinting;
                                          dispatch_semaphore_signal(semaphore);
                                      });
                    });
                else
                    dispatch_semaphore_signal(semaphore);
                
            };
            
            [self printPage:page+1
               formDocument:documentURL
                withPrinter:printer
            completionBlock:askToContinueBlock];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            if (!printNextPage)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completionBlock)
                        completionBlock(nil, YES);
                });
                return;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock)
                completionBlock(nil, NO);
        });
    });
}

- (void)printPage:(int)page formDocument:(NSURL *)documentURL withPrinter:(TXHPrinter *)printer completionBlock:(void(^)(NSError *error))completion
{
    TXHStarIOPrinter *starPrinter = (TXHStarIOPrinter *)printer;

    UIImage *img = [UIImage imageWithPDFURL:documentURL atWidth:STAR_PRINTER_MAXWIDTH atPage:page];
    img = [img imageWithBackground:[UIColor whiteColor]];
    
    if (starPrinter.printerType == TXHStarPortablePrinterTypePortable)
    {
        [self printBitmapWithPortName:starPrinter.portInfo.portName
                         portSettings:kPrinterPortSettingsPortable
                          imageSource:img
                         printerWidth:STAR_PRINTER_MAXWIDTH
                    compressionEnable:YES
                       pageModeEnable:NO
                           completion:completion];
    }
    else if (starPrinter.printerType == TXHStarPortablePrinterTypePOS)
    {
        [self printImageWithPortname:starPrinter.portInfo.portName
                        portSettings:kPrinterPortSettingsPOS
                        imageToPrint:img
                            maxWidth:STAR_PRINTER_MAXWIDTH
                   compressionEnable:YES
                      withDrawerKick:NO
                          completion:completion];
    }
}


#pragma mark - POS printers

- (void)printImageWithPortname:(NSString *)portName portSettings:(NSString*)portSettings imageToPrint:(UIImage*)imageToPrint maxWidth:(int)maxWidth compressionEnable:(BOOL)compressionEnable withDrawerKick:(BOOL)drawerKick completion:(void(^)(NSError *error))completion
{
    RasterDocument *rasterDoc = [[RasterDocument alloc] initWithDefaults:RasSpeed_Medium
                                                      endOfPageBehaviour:RasPageEndMode_FeedAndFullCut
                                                  endOfDocumentBahaviour:RasPageEndMode_FeedAndFullCut
                                                               topMargin:RasTopMargin_Standard
                                                              pageLength:0
                                                              leftMargin:0
                                                             rightMargin:0];

    StarBitmap *starbitmap = [[StarBitmap alloc] initWithUIImage:imageToPrint :maxWidth :false];
    
    NSMutableData *commandsToPrint = [[NSMutableData alloc] init];
    
    NSData *shortcommand = [rasterDoc BeginDocumentCommandData];
    [commandsToPrint appendData:shortcommand];
    
    shortcommand = [starbitmap getImageDataForPrinting:compressionEnable];
    [commandsToPrint appendData:shortcommand];
    
    shortcommand = [rasterDoc EndDocumentCommandData];
    [commandsToPrint appendData:shortcommand];
    
    if (drawerKick == YES) {
        [commandsToPrint appendBytes:POS_OPEN_DRAWER_COMMAND
                              length:sizeof(POS_OPEN_DRAWER_COMMAND) - 1];
    }
    
    [self sendCommand:commandsToPrint portName:portName portSettings:portSettings timeoutMillis:10000 completion:completion];
}

#pragma mark - portable printer

- (void)printBitmapWithPortName:(NSString*)portName portSettings:(NSString*)portSettings imageSource:(UIImage*)source printerWidth:(int)maxWidth compressionEnable:(BOOL)compressionEnable pageModeEnable:(BOOL)pageModeEnable completion:(void(^)(NSError *error))completion
{
    StarBitmap *starbitmap = [[StarBitmap alloc] initWithUIImage:source :maxWidth :false];
    NSData *commands = [starbitmap getImageMiniDataForPrinting:compressionEnable pageModeEnable:pageModeEnable];
    
    [self sendCommand:commands portName:portName portSettings:portSettings timeoutMillis:10000 completion:completion];
}

#pragma mark - Printer Communication

- (void)sendCommand:(NSData *)commandsToPrint portName:(NSString *)portName portSettings:(NSString *)portSettings timeoutMillis:(u_int32_t)timeoutMillis completion:(void(^)(NSError *error))completion
{
    int commandSize = (int)[commandsToPrint length];
    unsigned char *dataToSentToPrinter = (unsigned char *)malloc(commandSize);
    [commandsToPrint getBytes:dataToSentToPrinter];
    
    SMPort *starPort = nil;
    @try
    {
        starPort = [SMPort getPort:portName :portSettings :timeoutMillis];
        if (starPort == nil)
        {
            if (completion)
                completion([NSError printerErrorWithCode:kTXHPrinterFailToOpenPortError]);
            return;
        }
        
        StarPrinterStatus_2 status;
        [starPort beginCheckedBlock:&status :2];
        if (status.offline == SM_TRUE) {
            if (completion)
                completion([NSError printerErrorWithCode:kTXHPrinterOfflineError]);
            return;
        }
        
        struct timeval endTime;
        gettimeofday(&endTime, NULL);
        endTime.tv_sec += 30;
        
        int totalAmountWritten = 0;
        while (totalAmountWritten < commandSize)
        {
            int remaining = commandSize - totalAmountWritten;
            int amountWritten = [starPort writePort:dataToSentToPrinter :totalAmountWritten :remaining];
            totalAmountWritten += amountWritten;
            
            struct timeval now;
            gettimeofday(&now, NULL);
            if (now.tv_sec > endTime.tv_sec)
            {
                break;
            }
        }
        
        if (totalAmountWritten < commandSize)
        {
            if (completion)
                completion([NSError printerErrorWithCode:kTXHPrinterTimedOutError]);
            return;

        }
        
        starPort.endCheckedBlockTimeoutMillis = 30000;
        [starPort endCheckedBlock:&status :2];
        if (status.offline == SM_TRUE) {
            if (completion)
                completion([NSError printerErrorWithCode:kTXHPrinterOfflineError]);
            return;
        }
    }
    @catch (PortException *exception)
    {
        if (completion)
            completion([NSError printerErrorWithCode:kTXHPrinterTimedOutError]);
        return;

    }
    @finally
    {
        free(dataToSentToPrinter);
        [SMPort releasePort:starPort];

        if (completion)
            completion(nil);
        
        return;
    }
}

@end
