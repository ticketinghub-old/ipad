//
//  TXHSalesWizardViewController.m
//  TicketingHub
//
//  Created by Mark on 25/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesWizardViewController.h"

#import "ArrayDataSource.h"
#import "TXHSalesWizardTabelViewCell.h"
#import "TXHSalesContentProtocol.h"


static NSString * const kWizardTitleKey = @"WizardTitleKey";
static NSString * const kWizardDetailKey = @"WizardDetiailKey";

@interface TXHSalesWizardViewController ()

@property (assign, nonatomic) NSInteger currentStageInProgress;

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) ArrayDataSource *tableViewDataSource;

@end

@implementation TXHSalesWizardViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.data = @[@{kWizardTitleKey  : NSLocalizedString(@"Tickets", @"Tickets"),
                    kWizardDetailKey : NSLocalizedString(@"Select Type & Quantity", @"Select Type & Quantity")},
                  
                  @{kWizardTitleKey  : NSLocalizedString(@"Information", @"Information"),
                    kWizardDetailKey : NSLocalizedString(@"Customer details", @"Customer details")},
                  
                  @{kWizardTitleKey  : NSLocalizedString(@"Upgrades", @"Upgrades"),
                    kWizardDetailKey : NSLocalizedString(@"Add ticket extras", @"Add ticket extras")},
                  
                  @{kWizardTitleKey  : NSLocalizedString(@"Products", @"Products"),
                    kWizardDetailKey : NSLocalizedString(@"Optional extras", @"Optional extras")},
                  
                  @{kWizardTitleKey  : NSLocalizedString(@"Summary", @"Summary"),
                    kWizardDetailKey : NSLocalizedString(@"Review the order", @"Review the order")},
                  
                  @{kWizardTitleKey  : NSLocalizedString(@"Payment", @"Payment"),
                    kWizardDetailKey : NSLocalizedString(@"By card, cash or credit", @"By card, cash or credit")},
                  
                  @{kWizardTitleKey  : NSLocalizedString(@"Completed", @"Completed"),
                    kWizardDetailKey : NSLocalizedString(@"Print tickets and recipt", @"Print tickets and recipt")}
                  ];
    
    __weak typeof(self) selfie = self;
    self.tableViewDataSource = [[ArrayDataSource alloc] initWithItems:self.data
                                                       cellIdentifier:@"SalesWizardTabelViewCell"
                                                   configureCellBlock:^(id cell, id item) {
                                                       [selfie configureCell:cell withItem:item];
                                                   }];
    
    self.tableView.dataSource = self.tableViewDataSource;
    
    // Set up the initial condition
    [self configureWizardForStage:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)step {
    return self.currentStageInProgress;
}

- (NSUInteger)indexOfItem:(id)item
{
    return [self.data indexOfObject:item];
}

- (void)configureCell:(TXHSalesWizardTabelViewCell *)cell withItem:(NSDictionary *)item
{
    NSUInteger stepIndex = [self indexOfItem:item];
    
    [cell setTite:item[kWizardTitleKey]];
    [cell setDetails:item[kWizardDetailKey]];
    [cell setNumber:stepIndex];
    [cell setCompleted:stepIndex < self.currentStageInProgress];
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentStageInProgress < indexPath.row - 1)
        return nil;
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentStageInProgress = indexPath.row ;
    [self configureWizardForStage:self.currentStageInProgress];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

#pragma mark - Wizard business logic

- (void)configureWizardForStage:(NSInteger)stage
{
    if (self.currentStageInProgress < stage)
        self.currentStageInProgress = stage;
    
    [self.tableView reloadData];
    
    [[UIApplication sharedApplication] sendAction:@selector(didChangeOption:) to:nil from:self forEvent:nil];
}

- (void)moveToNextStep:(id)sender
{
    [self configureWizardForStage:self.currentStageInProgress + 1];
}

- (void)orderExpired
{
    self.currentStageInProgress = 0;
    [self configureWizardForStage:self.currentStageInProgress + 1];
}

@end
