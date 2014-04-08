//
//  SalesOrDoormanViewController.m
//  TicketingHub
//
//  Created by Mark Brindle on 07/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "SalesOrDoormanViewController.h"
@import CoreData;

#import "TXHProductsManager.h"
#import "TXHTicketingHubManager.h"
#import "TXHDateSelectorViewController.h"

#import "TXHEmbeddingSegue.h"
#import "TXHTransitionSegue.h"

#import "UIResponder+FirstResponder.h"
#import "ProductListControllerNotifications.h"
#import "UIColor+TicketingHub.h"
#import "TXHActivityLabelView.h"

@interface SalesOrDoormanViewController () <TXHDateSelectorViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UIView             *contentDetailView;

@property (strong, nonatomic) UIBarButtonItem *dateButton;

@property (strong, nonatomic) UIPopoverController *popover;

@property (strong, nonatomic) TXHProduct      *selectedProduct;
@property (strong, nonatomic) TXHAvailability *selectedAvailability;

@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet TXHActivityLabelView *activityView;

@property (assign, nonatomic, getter = isLoadingAvailabilites)          BOOL loadingAvailabilites;
@property (assign, nonatomic, getter = isLoadingAvailabilitesDetails)   BOOL loadingAvailabilitesDetails;


@end

@implementation SalesOrDoormanViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self setup];
    [self selectMode:nil];
 
    self.selectedProduct = [TXHPRODUCTSMANAGER selectedProduct];
    self.selectedAvailability = [TXHPRODUCTSMANAGER selectedAvailability];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productChanged:) name:TXHProductChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(availabilityChanged:) name:TXHAvailabilityChangedNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHProductChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TXHAvailabilityChangedNotification object:nil];
}

#pragma mark - Superclass overrides

- (void)prepareForSegue:(UIStoryboardSegue *)__unused segue sender:(id)__unused sender {
    if ([segue isMemberOfClass:[TXHTransitionSegue class]]) {
        TXHTransitionSegue *transitionSegue = (TXHTransitionSegue *)segue;

        transitionSegue.containerView = self.view;

        if ([segue.identifier isEqualToString:@"Flip To Salesman"]) {
            transitionSegue.animationOptions = UIViewAnimationOptionTransitionCurlDown;
        }
        else
        {
            transitionSegue.animationOptions = UIViewAnimationOptionTransitionCurlUp;
        }
    }
}

#pragma mark Actions

- (IBAction)selectMode:(id)__unused sender
{
    [self dismissVisiblePopover];
    [[UIResponder currentFirstResponder] resignFirstResponder];
    if (self.modeSelector.selectedSegmentIndex == 1)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Doorman" bundle:nil];
        UIViewController *destinationController = [storyboard instantiateInitialViewController];
        
        TXHEmbeddingSegue *segue = [[TXHEmbeddingSegue alloc] initWithIdentifier:@"Doorman"
                                                                          source:self
                                                                     destination:destinationController];
        segue.containerView = self.contentDetailView;
        [segue perform];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Salesman" bundle:nil];
        UIViewController *destinationController = [storyboard instantiateInitialViewController];

        TXHEmbeddingSegue *segue = [[TXHEmbeddingSegue alloc] initWithIdentifier:@"Salesman"
                                                                          source:self
                                                                     destination:destinationController];
        segue.containerView = self.contentDetailView;
        [segue perform];
    }

    self.selectedAvailability = nil;
    [self fetchAvailability];
}

#pragma mark - Setters / Getters

- (void)setSelectedProduct:(TXHProduct *)selectedProduct
{
    _selectedProduct = selectedProduct;

    self.selectedAvailability = nil;
    [self fetchAvailability];
    
    [self updateUI];
}

- (void)setSelectedAvailability:(TXHAvailability *)selectedAvailability
{
    _selectedAvailability = selectedAvailability;
    [self updateUI];
}

- (void)setLoadingAvailabilites:(BOOL)loadingAvailabilites
{
    _loadingAvailabilites = loadingAvailabilites;
    [self updateUI];
}

- (void)setLoadingAvailabilitesDetails:(BOOL)loadingAvailabilitesDetails
{
    _loadingAvailabilitesDetails = loadingAvailabilitesDetails;
    [self updateUI];
}

#pragma mark - Notification handlers

- (void)productChanged:(NSNotification *)notification
{
    self.selectedProduct = [notification userInfo][TXHSelectedProduct];
}

- (void)availabilityChanged:(NSNotification *)notification
{
    self.selectedAvailability = [notification userInfo][TXHSelectedAvailability];
}

#pragma mark - TXHDateSelectorViewController delegate methods

- (void)dateSelectorViewController:(TXHDateSelectorViewController *)controller didSelectAvailability:(TXHAvailability *)availability
{
    self.selectedAvailability = availability;

    [self loadDetailsForAvailability:availability];
    
    [self.popover dismissPopoverAnimated:YES];
}

- (void)loadDetailsForAvailability:(TXHAvailability *)availability
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:[availability dateString]];
    
    self.loadingAvailabilitesDetails = YES;
    __block typeof(self) wself = self;
    
    [TXHPRODUCTSMANAGER fetchSelectedProductAvailabilitiesFromDate:date
                                                            toDate:nil
                                                        withCoupon:nil
                                                        completion:^(NSArray *availabilities, NSError *error) {
                                                            
                                                            for (TXHAvailability *newAvilability in availabilities)
                                                            {
                                                                if ([newAvilability.dateString isEqualToString:[availability dateString]] &&
                                                                    [newAvilability.timeString isEqualToString:[availability timeString]])
                                                                {
                                                                    [TXHPRODUCTSMANAGER setSelectedAvailability:newAvilability];
                                                                    break;
                                                                }
                                                            }
                                                            wself.loadingAvailabilitesDetails = NO;
                                                        }];
    
}

#pragma mark - Private

- (void)setup
{
    [self.navigationController.navigationBar setBarTintColor:[UIColor txhDarkBlueColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:24.0f],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]};

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    self.dateButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(selectDate:)];

    UIBarButtonItem *handleItem = self.navigationItem.leftBarButtonItem;

    handleItem.tintColor = [UIColor colorWithRed:188.0f / 255.0f
                                           green:207.0f / 255.0f
                                            blue:219.0f / 255.0f
                                           alpha:1.0f];

    [self.navigationItem setLeftBarButtonItems:@[self.navigationItem.leftBarButtonItem, self.dateButton]];
}

-(void)selectDate:(id)__unused sender
{
    [self dismissVisiblePopover];
    [[UIResponder currentFirstResponder] resignFirstResponder];

    TXHDateSelectorViewController *dateViewController = [[TXHDateSelectorViewController alloc] initWithSunday:NO];
    dateViewController.delegate = self;

    [self.view layoutIfNeeded];

    self.popover = [[UIPopoverController alloc] initWithContentViewController:dateViewController];
    [self.popover presentPopoverFromBarButtonItem:self.dateButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)toggleMenu:(id)__unused sender
{
    [self dismissVisiblePopover];
    [[UIResponder currentFirstResponder] resignFirstResponder];
    [[UIApplication sharedApplication] sendAction:@selector(showOrHideVenueList:) to:nil from:self forEvent:nil];
}

- (void)dismissVisiblePopover
{
    [self.popover dismissPopoverAnimated:YES];
}

- (void)fetchAvailability
{
    __weak typeof(self) wself = self;

    self.loadingAvailabilites = YES;
    
    if (self.selectedProduct)
        [TXHPRODUCTSMANAGER fetchSelectedProductAvailabilitiesFromDate:[NSDate date]
                                                                toDate:[[NSDate date] dateByAddingDays:60]
                                                            withCoupon:nil
                                                            completion:^(NSArray *availabilities, NSError *error) {
                                                                wself.loadingAvailabilites = NO;
                                                                [wself selectFirstAvailabilitiesFrom:availabilities];
                                                            }];
}

- (void)selectFirstAvailabilitiesFrom:(NSArray *)availabilities
{
    __weak typeof(self) wself = self;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!wself.selectedAvailability)
        {
            NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateString" ascending:YES];
            NSArray *sortedArray = [availabilities sortedArrayUsingDescriptors:@[valueDescriptor]];
            
            wself.selectedAvailability = [sortedArray firstObject];
            [wself loadDetailsForAvailability:wself.selectedAvailability];
        }
    });
}

#pragma mark UI stuff

- (void)updateUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateActivityIndicator];
        [self updateTitle];
        [self updateAvailabilityButton];
        [self updateModeSelector];
    });
}

- (void)updateActivityIndicator
{
    if (self.loadingAvailabilites)
        [self.activityView showWithMessage:NSLocalizedString(@"SD_LOADING_AVAILABILITIES_LABEL", nil) indicatorHidden:NO];
    else if (self.loadingAvailabilitesDetails)
        [self.activityView showWithMessage:NSLocalizedString(@"SD_LOADING_AVAILABILITY_DETAILS_LABEL", nil) indicatorHidden:NO];
    else if (!self.selectedProduct || !self.selectedAvailability)
        [self.activityView showWithMessage:NSLocalizedString(@"SD_NO_AVAILABILITIES_LABEL", nil) indicatorHidden:YES];
    else
        [self.activityView hide];
}

- (void)updateTitle
{
    self.title = self.selectedProduct ? self.selectedProduct.name : @"";
}

- (void)updateModeSelector
{
    self.modeSelector.enabled = (self.selectedProduct != nil);
}

- (void)updateAvailabilityButton
{
    self.dateButton.enabled = (self.selectedProduct != nil);
    self.dateButton.title = [self dateTimeButtonTitleForAvailability:self.selectedAvailability];
}

- (NSString *)dateTimeButtonTitleForAvailability:(TXHAvailability *)availability
{
    NSString *dateTimeButtonTitle;
    
    if (availability)
        dateTimeButtonTitle = [NSString stringWithFormat:@"%@ %@", availability.dateString, availability.timeString];
    else
        dateTimeButtonTitle = NSLocalizedString(@"Select Date", nil);
    
    return dateTimeButtonTitle;
}

#pragma mark - loading view

- (TXHActivityLabelView *)activityView
{
    if (!_activityView) {
        TXHActivityLabelView *activityView = [TXHActivityLabelView getInstance];
        activityView.frame = self.view.bounds;
        activityView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [activityView hide];
    
        [self.view addSubview:activityView];
        _activityView = activityView;
    }
    return _activityView;
}

@end
