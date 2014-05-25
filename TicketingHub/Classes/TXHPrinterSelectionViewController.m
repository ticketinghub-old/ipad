//
//  TXHPrinterSelectionViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPrinterSelectionViewController.h"

#import "TXHPrintersManager.h"
#import "TXHPrinter.h"

#import "ArrayDataSource.h"

#import "UIColor+TicketingHub.h"
#import "UIFont+TicketingHub.h"

@interface TXHPrinterSelectionViewController ()

@property (nonatomic, strong) NSArray *printers;
@property (nonatomic, strong) ArrayDataSource *datasource;
@property (nonatomic, strong) TXHPrintersManager *printersManager;

@end

@implementation TXHPrinterSelectionViewController

- (instancetype)initWithPrintersManager:(TXHPrintersManager *)manager
{
    if (!manager || !(self = [super init]))
        return nil;
    
    self.printersManager = manager;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"printerCell"];
    self.tableView.delegate = self;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    [self loadPrinters];
}

- (void)loadPrinters
{
    __weak typeof(self) wself = self;
    [self.printersManager fetchAvailablePrinters:^(NSSet *printers, NSError *error) {
        
        NSArray *filteredPrinters = [printers allObjects];
        
        if (wself.onlyPrintersWithDrawer)
            filteredPrinters = [self filterOnlyDrawerPrintersFromPrinters:filteredPrinters];
        
        wself.printers = filteredPrinters;
    }];
}

- (NSArray *)filterOnlyDrawerPrintersFromPrinters:(NSArray *)printers
{
    NSMutableArray *drawerPrinters = [NSMutableArray array];
    for (TXHPrinter *printer in printers)
    {
        if (printer.canOpenDrawer)
            [drawerPrinters addObject:printer];
    }
    
    return [drawerPrinters copy];
}

- (void)setPrinters:(NSArray *)printers
{
    _printers = printers;
    
    self.datasource = [[ArrayDataSource alloc] initWithItems:printers
                                              cellIdentifier:@"printerCell"
                                          configureCellBlock:^(id cell, id item) {
                                              UITableViewCell *aCell = (UITableViewCell *)cell;
                                              TXHPrinter *printer = (TXHPrinter *)item;
                                              
                                              aCell.textLabel.text = printer.displayName;
                                          }];
    if (![printers count])
        [self addNoPrintersLabel];
    
    [self.tableView reloadData];
}

- (void)addNoPrintersLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor     = [UIColor txhDarkBlueColor];
    label.font          = [UIFont txhThinFontWithSize:23.0];
    label.text          = NSLocalizedString(@"NO_PRINTERS_TEXT", nil);
    
    [self.view addSubview:label];
}

- (void)setDatasource:(ArrayDataSource *)datasource
{
    _datasource = datasource;
    
    self.tableView.dataSource = datasource;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXHPrinter *printer = (TXHPrinter *)[self.datasource itemAtIndexPath:indexPath];
    
    [self.delegate txhPrinterSelectionViewController:self
                                    didSelectPrinter:printer];
}

@end
