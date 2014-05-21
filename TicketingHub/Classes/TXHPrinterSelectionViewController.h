//
//  TXHPrinterSelectionViewController.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHPrinter;
@class TXHPrintersManager;
@class TXHPrinterSelectionViewController;

@protocol TXHPrinterSelectionViewControllerDelegate <NSObject>

- (void)txhPrinterSelectionViewController:(TXHPrinterSelectionViewController *)controller
                         didSelectPrinter:(TXHPrinter *)printer;
@end




@interface TXHPrinterSelectionViewController : UITableViewController

@property (nonatomic, assign) BOOL onlyPrintersWithDrawer;

- (instancetype)initWithPrintersManager:(TXHPrintersManager *)manager;

@property (nonatomic, weak) id<TXHPrinterSelectionViewControllerDelegate> delegate;

@end
