//
//  SalesOrDoormanViewController.m
//  TicketingHub
//
//  Created by Mark Brindle on 07/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "SalesOrDoormanViewController.h"
@import CoreData;

#import "TXHTicketingHubClient+AppExtension.h"
#import "TXHDateSelectorViewController.h"
#import "TXHEmbeddingSegue.h"
#import "TXHTimeSlot_old.h"
#import "TXHTransitionSegue.h"
#import "ProductListControllerNotifications.h"

@interface SalesOrDoormanViewController () <TXHDateSelectorViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UIView *contentDetailView;

@property (strong, nonatomic) UIBarButtonItem *dateButton;

@property (strong, nonatomic) UIPopoverController *datePopover;
@property (strong, nonatomic) UIPopoverController *timePopover;

@property (strong, nonatomic) NSDate *selectedDate;
@property (assign, nonatomic) NSTimeInterval selectedTime;
@property (assign, nonatomic) BOOL timeSelected;

@end

@implementation SalesOrDoormanViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self selectMode:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productChanged:) name:TXHProductChangedNotification object:nil];
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

- (IBAction)selectMode:(id)__unused sender {
    [self dismissVisiblePopover];
    if (self.modeSelector.selectedSegmentIndex == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Doorman" bundle:nil];

        UIViewController *destinationController = [storyboard instantiateInitialViewController];
        
        TXHEmbeddingSegue *segue = [[TXHEmbeddingSegue alloc] initWithIdentifier:@"Doorman"
                                                                          source:self
                                                                     destination:destinationController];
        segue.containerView = self.contentDetailView;

        [segue perform];
        
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Salesman" bundle:nil];

        UIViewController *destinationController = [storyboard instantiateInitialViewController];

        TXHEmbeddingSegue *segue = [[TXHEmbeddingSegue alloc] initWithIdentifier:@"Salesman"
                                                                          source:self
                                                                     destination:destinationController];
        segue.containerView = self.contentDetailView;
        
        [segue perform];
    }
}

#pragma mark - Custom accessors

#pragma mark - Setters / Getters

- (void)setSelectedProduct:(TXHProduct *)selectedProduct
{
    if (selectedProduct && _selectedProduct != selectedProduct)
    {
        _selectedProduct = selectedProduct;
        
        self.title = selectedProduct.name;
        
        if ([self isViewLoaded]) {
            [self resetDateButtonLabel];
        }
    }
}

#pragma mark - Notification handlers

- (void)productChanged:(NSNotification *)notification {
    self.selectedProduct = [notification userInfo][TXHSelectedProduct];
    
    // forward taht to
}


#pragma mark - TXHDateSelectorViewController delegate methods

- (void)dateSelectorViewController:(TXHDateSelectorViewController *)controller didSelectAvailability:(TXHAvailability *)availability
{
    self.dateButton.title = [self dateTimeButtonTitleForAvailability:availability];

    [self.datePopover dismissPopoverAnimated:YES];
    [self updateControlsForUserInteraction];
}

- (NSString *)dateTimeButtonTitleForAvailability:(TXHAvailability *)availability
{
    NSString *dateTimeButtonTitle = [NSString stringWithFormat:@"%@ %@", availability.dateString, availability.timeString];

    return dateTimeButtonTitle;
}

#pragma mark - Private

- (void)setup {
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:38.0f / 255.0f
                                                                             green:65.0f / 255.0f
                                                                              blue:87.0f / 255.0f
                                                                             alpha:1.0f]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:24.0f],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]};


    self.dateButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(selectDate:)];

    UIBarButtonItem *handleItem = self.navigationItem.leftBarButtonItem;

    handleItem.tintColor = [UIColor colorWithRed:188.0f / 255.0f
                                           green:207.0f / 255.0f
                                            blue:219.0f / 255.0f
                                           alpha:1.0f];

    [self.navigationItem setLeftBarButtonItems:@[self.navigationItem.leftBarButtonItem, self.dateButton]];
    
    [self resetDateButtonLabel];
}

-(void)selectDate:(id)__unused sender {
    [self dismissVisiblePopover];

    TXHDateSelectorViewController *dateViewController = [[TXHDateSelectorViewController alloc] initWithSunday:NO];
    dateViewController.delegate = self;

    [self.view layoutIfNeeded];

    self.datePopover = [[UIPopoverController alloc] initWithContentViewController:dateViewController];
    [self.datePopover presentPopoverFromBarButtonItem:self.dateButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)toggleMenu:(id)__unused sender {
    [self dismissVisiblePopover];
    [[UIApplication sharedApplication] sendAction:@selector(showOrHideVenueList:) to:nil from:self forEvent:nil];
}

- (void)dismissVisiblePopover {
    // Whenever a control receives focus we want to dismiss a visible popover
    if (self.datePopover.isPopoverVisible) {
        [self.datePopover dismissPopoverAnimated:YES];
    }
    if (self.timePopover.isPopoverVisible) {
        [self.timePopover dismissPopoverAnimated:YES];
    }
}

// Needs to be refactored
- (void)updateControlsForUserInteraction {
    BOOL enabled = (self.selectedProduct != nil);
    //    self.modeSelector.userInteractionEnabled = enabled;
    self.dateButton.enabled = enabled;
}

- (void)resetDateButtonLabel {
    self.dateButton.title = @"<Date>";
}


@end
