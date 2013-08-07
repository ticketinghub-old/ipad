//
//  TXHSalesInformationDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesInformationDetailsViewController.h"

#import "TXHSalesContentProtocol.h"

@interface TXHSalesInformationDetailsViewController () <TXHSalesContentProtocol>

// A reference to the timer view controller
@property (retain, nonatomic) TXHSalesTimerViewController *timerViewController;

// A reference to the completion view controller
@property (retain, nonatomic) TXHSalesCompletionViewController *completionViewController;

@end

@implementation TXHSalesInformationDetailsViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.timerViewController resetPresentationAnimated:NO];
    self.timerViewController.stepTitle = NSLocalizedString(@"Customer Details", @"Customer Details");
    self.timerViewController.duration = 25.0f;
    [self.timerViewController hideCountdownTimer:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Datasource & Delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#pragma unused (collectionView, section)
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}


@end
