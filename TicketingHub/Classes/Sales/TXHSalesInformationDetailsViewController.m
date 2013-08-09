//
//  TXHSalesInformationDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

/*
 {
     "id": 4000,
     "currency": "GBP",
     "opt_out": false,
     "expires_in": 600,
     "total": 3400,
     "commission": 200,
     "customer": null,
     "coupon": null,
     "payment": null,
     "products": [
         {
             "id": 3000,
             "name": "Guide Book",
             "description": "A detailed outline of the venue which you can read",
             "price": 300,
             "quantity": 2,
             "errors": {}
         }
     ],
     "tickets": [
         {
         "id": 7000,
         "valid_from": "2013-05-27T07:00:00.000+01:00",
         "expires_at": "2013-05-27T11:00:00.000+01:00",
         "price": 800,
         "commission": 50,
         "voucher": null,
         "upgrades": [],
         "tier": {
             "id": 2000,
             "name": "Child",
             "description": "Under 18 years old"
         },
         "errors": {}
     },
     {
         "id": 7001,
         "valid_from": "2013-05-27T07:00:00.000+01:00",
         "expires_at": "2013-05-27T11:00:00.000+01:00",
         "price": 800,
         "commission": 50,
         "voucher": null,
         "upgrades": [],
         "tier": {
             "id": 2000,
             "name": "Child",
             "description": "Under 18 years old"
         },
         "errors": {}
     },
     {
         "id": 7002,
         "valid_from": "2013-05-27T07:00:00.000+01:00",
         "expires_at": "2013-05-27T11:00:00.000+01:00",
         "price": 1200,
         "commission": 100,
         "voucher": null,
         "upgrades": [],
         "tier": {
             "id": 2001,
             "name": "Adult",
             "description": "18 years old or more"
         },
         "errors": {
             "customer": [
                 "can't be blank"
             ]
         }
         }
    ],
    "errors": {}
 }

*/

#import "TXHSalesInformationDetailsViewController.h"

#import "TXHSalesContentProtocol.h"
#import "TXHSalesInformationHeader.h"
#import "TXHSalesInformationTextCell.h"

@interface TXHSalesInformationDetailsViewController () <TXHSalesContentProtocol>

// A reference to the timer view controller
@property (retain, nonatomic) TXHSalesTimerViewController *timerViewController;

// A reference to the completion view controller
@property (retain, nonatomic) TXHSalesCompletionViewController *completionViewController;

// A completion block to be run when this step is completed
@property (copy) void (^completionBlock)(void);

@end

@implementation TXHSalesInformationDetailsViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    __block typeof(self) blockSelf = self;
    self.completionBlock = ^{
        // Post the order for tickets
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
        self.timerViewController.stepTitle = NSLocalizedString(@"Customer Details", @"Customer Details");
        self.timerViewController.duration = 600.0f;
        [self.timerViewController hideCountdownTimer:NO];
    }
}

- (void)configureCompletionViewController {
    // Set up the completion view controller to reflect ticket tier details
    [self.completionViewController setCompletionBlock:self.completionBlock];
}

#pragma mark - Collection View Datasource & Delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#pragma unused (collectionView, section)
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXHSalesInformationTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.ticket = @"First Name";
            break;
        case 1:
            cell.ticket = @"Last Name";
            [cell hasErrors:YES];
            break;
        case 2:
            cell.ticket = @"Email";
            break;
        default:
            cell.ticket = [NSString stringWithFormat:@"indexPath:{%d,%d}", indexPath.section, indexPath.row];
            break;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        TXHSalesInformationHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TXHSalesInformationHeader" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
                header.tierTitle = [NSString stringWithFormat:@"Adult"];
                break;
            case 1:
                header.tierTitle = [NSString stringWithFormat:@"Under 18"];
                break;
            default:
                header.tierTitle = [NSString stringWithFormat:@"Section:%d", indexPath.section];
                break;
        }
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TXHSalesInformationFooter" forIndexPath:indexPath];
        return footer;
    }
    return nil;
}

@end
