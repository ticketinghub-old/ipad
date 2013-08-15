//
//  TXHSalesSummaryViewController.m
//  TicketingHub
//
//  Created by Mark on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesSummaryViewController.h"

#import "TXHSalesCompletionViewController.h"
#import "TXHSalesContentProtocol.h"
#import "TXHSalesSummaryCell.h"
#import "TXHSalesSummaryExtraProductsCell.h"
#import "TXHSalesSummaryHeader.h"
#import "TXHSalesTimerViewController.h"

@interface TXHSalesSummaryViewController () <TXHSalesContentProtocol, UICollectionViewDelegateFlowLayout>

// A reference to the timer view controller
@property (retain, nonatomic) TXHSalesTimerViewController *timerViewController;

// A reference to the completion view controller
@property (retain, nonatomic) TXHSalesCompletionViewController *completionViewController;

// A completion block to be run when this step is completed
@property (copy) void (^completionBlock)(void);

// A mutable collection of sections indicating their expanded status.
@property (strong, nonatomic) NSMutableDictionary *sections;

@end

@implementation TXHSalesSummaryViewController

@synthesize timerViewController = _timerViewController;
@synthesize completionViewController = _completionViewController;
@synthesize completionBlock = _completionBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.sections = [NSMutableDictionary dictionary];
    // Set only the first section to be expanded
    self.sections[@(0)] = @YES;
    for (int index = 0; index < 4; index++) {
        self.sections[@(index)] = @NO;
    }
    self.sections[@(self.sections.count - 1)] = @YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    __block typeof(self) blockSelf = self;
    self.completionBlock = ^{
        // Update the order for tickets
        NSLog(@"Update order for %@", blockSelf);
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureTimerViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TXHSalesTimerViewController *)timerViewController {
    return _timerViewController;
}

- (void)setTimerViewController:(TXHSalesTimerViewController *)timerViewController {
    _timerViewController = timerViewController;
    [self configureTimerViewController];
}

- (TXHSalesCompletionViewController *)completionViewController {
    return _completionViewController;
}

- (void)setCompletionViewController:(TXHSalesCompletionViewController *)completionViewController {
    _completionViewController = completionViewController;
    [self configureCompletionViewController];
}

- (void (^)(void))completionBlock {
    return _completionBlock;
}

- (void)setCompletionBlock:(void (^)(void))completionBlock {
    _completionBlock = completionBlock;
    [self configureCompletionViewController];
}

- (void)configureTimerViewController {
    // Set up the timer view to reflect our details
    if (self.timerViewController) {
        [self.timerViewController resetPresentationAnimated:NO];
        self.timerViewController.stepTitle = NSLocalizedString(@"Review the order", @"Review the order");
        [self.timerViewController hideCountdownTimer:NO];
    }
}

- (void)configureCompletionViewController {
    // Set up the completion view controller to reflect ticket tier details
    [self.completionViewController setCompletionBlock:self.completionBlock];
}

#pragma mark - Collection View Datasource & Delegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // The last section (Extra Products) only has one cell
    if (section == self.sections.count - 1) {
        return 1;
    }
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == (self.sections.count - 1)) {
        TXHSalesSummaryExtraProductsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TXHSalesSummaryExtraProductsCell" forIndexPath:indexPath];
        cell.products = @[
                          @{@"description": @"Guide Book", @"price" : @(6.00), @"quantity" : @(1)},
                          @{@"description": @"Local Map", @"price" : @(2.00), @"quantity" : @(2)},
                          @{@"description": @"Refreshments", @"price" : @(2.00), @"quantity" : @(1)},
                          ];
        return cell;
    } else {
    TXHSalesSummaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TXHSalesSummaryCell" forIndexPath:indexPath];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        NSDictionary *attributesDict = @{NSFontAttributeName: [UIFont systemFontOfSize:28.0f]};
        NSMutableAttributedString *attString;
        TXHSalesSummaryHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TXHSalesSummaryHeader" forIndexPath:indexPath];
        header.section = indexPath.section;
        switch (indexPath.section) {
            case 0:
                attString = [[NSMutableAttributedString alloc] initWithString:@"Oliver Morgan Adult" attributes:attributesDict];
                [attString addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:14.0f]
                                  range:NSMakeRange(14, 5)];
                
                [attString addAttribute: NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(14, 5)];
                header.ticketTitle = attString;
                header.totalPrice = @(10.5);
                break;
            case 1:
                attString = [[NSMutableAttributedString alloc] initWithString:@"Ben Thompson Adult" attributes:attributesDict];
                [attString addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:14.0f]
                                  range:NSMakeRange(13, 5)];
                
                [attString addAttribute: NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(13, 5)];
                header.ticketTitle = attString;
                header.totalPrice = @(11.5);
                break;
            default:
                if (indexPath.section == self.sections.count - 1) {
                    attString = [[NSMutableAttributedString alloc] initWithString:@"Extra Products" attributes:attributesDict];
                } else {
                    attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Child #%d", indexPath.row] attributes:attributesDict];
                }
                [attString addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:14.0f]
                                  range:NSMakeRange(6, 2)];
                
                [attString addAttribute: NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(6, 2)];
                header.ticketTitle = attString;
                header.totalPrice = @(8);
                break;
        }
        header.isExpanded = [self.sections[@(indexPath.section)] boolValue];
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TXHSalesUpgradeFooter" forIndexPath:indexPath];
        return footer;
    }
    return nil;
}

- (void)makeCellVisible:(id)sender {
    UICollectionViewCell *cell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - Action methods

- (void)toggleSection:(id)sender {
    TXHSalesSummaryHeader *header = sender;
    self.sections[@(header.section)] = [NSNumber numberWithBool:header.isExpanded];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:header.section]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *expanded = self.sections[@(indexPath.section)];
    CGFloat width = 440.0f;
    if ((indexPath.section == self.sections.count - 1) && (indexPath.row == 1)) {
        width = 220.0f;
    }
    CGFloat height = expanded.boolValue ? 112.0f : 0.0f;
    CGSize size = CGSizeMake(width, height);
    return size;
}

@end
