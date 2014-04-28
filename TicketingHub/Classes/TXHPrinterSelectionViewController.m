//
//  TXHPrinterSelectionViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPrinterSelectionViewController.h"
#import "TXHPrintersManager.h"
#import "ArrayDataSource.h"
#import "TXHPrinter.h"

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
    
    [self loadPrinters];
}

- (void)loadPrinters
{
    __weak typeof(self) wself = self;
    [self.printersManager fetchAvailablePrinters:^(NSSet *printers, NSError *error) {
        wself.printers = [printers allObjects];
    }];
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
    [self.tableView reloadData];
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
