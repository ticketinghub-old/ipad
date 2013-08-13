//
//  TXHSalesUpgradeDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesUpgradeDetailsViewController.h"

#import "TXHSalesCompletionViewController.h"
#import "TXHSalesContentProtocol.h"
#import "TXHSalesTimerViewController.h"
#import "TXHSalesUpgradeCell.h"
#import "TXHSalesUpgradeHeader.h"
#import "UIView+TXHAnimationConversions.h"

@interface TXHSalesUpgradeDetailsViewController () <TXHSalesContentProtocol, UICollectionViewDelegateFlowLayout>

// A reference to the timer view controller
@property (retain, nonatomic) TXHSalesTimerViewController *timerViewController;

// A reference to the completion view controller
@property (retain, nonatomic) TXHSalesCompletionViewController *completionViewController;

// A completion block to be run when this step is completed
@property (copy) void (^completionBlock)(void);

// A mutable collection of sections indicating their expanded status.
@property (strong, nonatomic) NSMutableDictionary *sections;
@end

@implementation TXHSalesUpgradeDetailsViewController

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
    // For now set sections to be expanded
    self.sections[@(0)] = @YES;
    for (int index = 1; index < 4; index++) {
        self.sections[@(index)] = @NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        self.timerViewController.stepTitle = NSLocalizedString(@"Add Ticket extras", @"Add Ticket extras");
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
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 8;
        default:
            return 2;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXHSalesUpgradeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TXHSalesUpgradeCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.upgradeName = @"Upgrade";
                    cell.upgradePrice = @(12.50);
                    cell.upgradeDescription = @"A rather fetching little doodah\nWill be well worth adding to your ticket.  Trust me; I know all about these things!";
                    break;
                case 1:
                    cell.upgradeName = @"Upgrade 2";
                    cell.upgradePrice = @(3);
                    cell.upgradeDescription = @"Something to drink at the interval?";
                    cell.isSelected = YES;
                    break;
                case 2:
                    cell.upgradeName = @"Upgrade 3";
                    cell.upgradePrice = @(2.50);
                    cell.upgradeDescription = @"Perhaps a snack appeals to you?";
                    break;
                case 3:
                    cell.upgradeName = @"Upgrade 4";
                    cell.upgradePrice = @(0);
                    cell.upgradeDescription = @"Programme of events for the show";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            cell.upgradeName = [NSString stringWithFormat:@"Upgrade%@", indexPath.row == 0 ? @"" : [NSString stringWithFormat:@" %d", indexPath.row + 1]];
            cell.upgradePrice = @(1.37 * indexPath.row);
            cell.upgradeDescription = @"A description of your upgrade!";
            break;
        default:
            cell.upgradeName = [NSString stringWithFormat:@"Upgrade%@", indexPath.row == 0 ? @"" : [NSString stringWithFormat:@" %d", indexPath.row + 1]];
            cell.upgradePrice = @(1.37 * indexPath.row);
            cell.upgradeDescription = @"A description of your upgrade!";
            cell.isSelected = indexPath.row % 3;
            break;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        NSDictionary *attributesDict = @{NSFontAttributeName: [UIFont systemFontOfSize:28.0f]};
        NSMutableAttributedString *attString;
        TXHSalesUpgradeHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TXHSalesUpgradeHeader" forIndexPath:indexPath];
        header.section = indexPath.section;
        switch (indexPath.section) {
            case 0:
                attString = [[NSMutableAttributedString alloc] initWithString:@"Oliver Morgan Adult" attributes:attributesDict];
                [attString addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:14.0f]
                                  range:NSMakeRange(14, 5)];
                
                [attString addAttribute: NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(14, 5)];
                header.ticketTitle = attString;
                break;
            case 1:
                attString = [[NSMutableAttributedString alloc] initWithString:@"Ben Thompson Adult" attributes:attributesDict];
                [attString addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:14.0f]
                                  range:NSMakeRange(13, 5)];
                
                [attString addAttribute: NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(13, 5)];
                header.ticketTitle = attString;
                break;
            default:
                attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Child #%d", indexPath.row] attributes:attributesDict];
                [attString addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:14.0f]
                                  range:NSMakeRange(6, 2)];
                
                [attString addAttribute: NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(6, 2)];
                header.ticketTitle = attString;
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
    TXHSalesUpgradeHeader *header = sender;
    NSLog(@"%s - Expanded:%@", __FUNCTION__, header.isExpanded ? @"YES" : @"NO");
    self.sections[@(header.section)] = [NSNumber numberWithBool:header.isExpanded];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:header.section]];
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, keyboardSize.width, 0.0f);
    self.collectionView.contentInset = contentInsets;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *keyboardAnimationDetail = [notification userInfo];
    UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    UIViewAnimationOptions options = [UIView txhAnimationOptionsFromAnimationCurve:animationCurve];
    // Beta 4 had issues with the animation options, so fixed at the moment
    options = UIViewAnimationOptionCurveEaseInOut;
    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.collectionView.contentInset = UIEdgeInsetsZero;
        [self.collectionView layoutIfNeeded];
    } completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *expanded = self.sections[@(indexPath.section)];
    CGSize size = CGSizeMake(220.0f, expanded.boolValue ? 112.0f : 0.0f);
    return size;
}

@end
