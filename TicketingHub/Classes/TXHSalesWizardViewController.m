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

// An empty circle image indicating a stage not started
@property (strong, nonatomic) UIImage *notStarted;

// A completed image (checkmark on green background) indicating a stage is completed
@property (strong, nonatomic) UIImage *completed;

// An indication of the current stage in progress
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
    
    // grab the button images
    self.notStarted = [UIImage imageNamed:@"EmptyCircle"];
    self.completed = [UIImage imageNamed:@"item-check"];
    
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // If the previous stage has been completed we can select this cell
    if (self.currentStageInProgress < indexPath.row - 1) {
        return nil;
    }
    
    // Allow the cell to be selected
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentStageInProgress = indexPath.row ;
    [self configureWizardForStage:self.currentStageInProgress];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Wizard business logic

- (void)configureWizardForStage:(NSInteger)stage {

    if (self.currentStageInProgress < stage) {
        self.currentStageInProgress = stage;
    }
    
    [self.tableView reloadData];
    
    // Send an action to inform whomever is interested of a selection
    [[UIApplication sharedApplication] sendAction:@selector(didChangeOption:) to:nil from:self forEvent:nil];
}

- (void)moveToNextStep:(id)sender {
    // Perform any completion processing
    [self configureWizardForStage:self.currentStageInProgress + 1];
}

- (void)orderExpired {
    self.currentStageInProgress = 0;
    [self configureWizardForStage:self.currentStageInProgress + 1];
}

@end
