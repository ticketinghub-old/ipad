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
#import "TXHTimeslotSelectorViewController.h"
#import "TXHTransitionSegue.h"
#import "ProductListControllerNotifications.h"

@interface SalesOrDoormanViewController () <TXHDateSelectorViewDelegate, TXHTimeSlotSelectorDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UIView *contentDetailView;

@property (strong, nonatomic) UIBarButtonItem *dateButton;
@property (strong, nonatomic) UIBarButtonItem *timeButton;

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

        //        destinationController.containerNavigationItem = self.navigationItem;

        TXHEmbeddingSegue *segue = [[TXHEmbeddingSegue alloc] initWithIdentifier:@"Doorman"
                                                                          source:self destination:destinationController];
        segue.containerView = self.contentDetailView;

        [segue perform];
        
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Salesman" bundle:nil];

        UIViewController *destinationController = [storyboard instantiateInitialViewController];

        //        destinationController.containerNavigationItem = self.navigationItem;

        TXHEmbeddingSegue *segue = [[TXHEmbeddingSegue alloc] initWithIdentifier:@"Salesman"
                                                                          source:self destination:destinationController];
        segue.containerView = self.contentDetailView;
        
        [segue perform];
    }
}

#pragma mark - Custom accessors

- (void)setSelectedProduct:(TXHProduct *)selectedProduct {
    _selectedProduct = selectedProduct;

    // More stuff needed here to reset the UI if the view is loaded
    if ([self isViewLoaded]) {
        [self resetDateAndTimeButtonLabels];
    }
}

#pragma mark - Notification handlers

- (void)productChanged:(NSNotification *)notification {
    self.selectedProduct = [notification userInfo][TXHSelectedProduct];
}


#pragma mark - TXHDateSelectorViewController delegate methods

- (void)dateSelectorViewController:(TXHDateSelectorViewController *)__unused controller didSelectDate:(NSDate *)date {
    self.selectedDate = date;

    // Having selected a date; we now need to select a timeslot; so reset the time selected flag
    self.timeSelected = NO;

    // Update the date picker barbutton control
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.dateButton.title = [dateFormatter stringFromDate:self.selectedDate];
    [self.datePopover dismissPopoverAnimated:YES];
    [self updateControlsForUserInteraction];
}

#pragma mark - TXHTimeSelectorViewController delegate methods

- (void)timeSlotSelectorViewController:(TXHTimeslotSelectorViewController *)__unused controller didSelectTime:(TXHTimeSlot_old *)time {
    self.selectedTime = time.timeSlotStart;
    self.timeSelected = YES;

    // Update the time barbutton control
    static NSDateFormatter *timeFormatter = nil;
    if (timeFormatter == nil) {
        timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateStyle = NSDateFormatterNoStyle;
        timeFormatter.timeStyle = NSDateFormatterMediumStyle;
    }
    NSDate *dateAndTime = [self.selectedDate dateByAddingTimeInterval:self.selectedTime];
    self.timeButton.title = [timeFormatter stringFromDate:dateAndTime];
    [self.timePopover dismissPopoverAnimated:YES];
    [self updateControlsForUserInteraction];

}

#pragma mark - Private

- (void)setup {
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:38.0f / 255.0f
                                                                             green:65.0f / 255.0f
                                                                              blue:87.0f / 255.0f
                                                                             alpha:1.0f]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:24.0f],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]};



    NSString *dateButtonPlaceholder = @"<Date>";
    NSString *timeButtonPlaceholder = @"<Time>";

    self.dateButton = [[UIBarButtonItem alloc] initWithTitle:dateButtonPlaceholder style:UIBarButtonItemStyleBordered target:self action:@selector(selectDate:)];
    self.timeButton = [[UIBarButtonItem alloc] initWithTitle:timeButtonPlaceholder style:UIBarButtonItemStylePlain target:self action:@selector(selectTime:)];

    UIBarButtonItem *handleItem = self.navigationItem.leftBarButtonItem;

    handleItem.tintColor = [UIColor colorWithRed:188.0f / 255.0f
                                           green:207.0f / 255.0f
                                            blue:219.0f / 255.0f
                                           alpha:1.0f];

    [self.navigationItem setLeftBarButtonItems:@[self.navigationItem.leftBarButtonItem, self.dateButton, self.timeButton]];

}

-(void)selectDate:(id)__unused sender {
    [self dismissVisiblePopover];

    TXHDateSelectorViewController *dateViewController = [self.storyboard instantiateViewControllerWithIdentifier:DateSelectorViewControllerStoryboardIdentifier];
    dateViewController.delegate = self;

    [self.view layoutIfNeeded];

    self.datePopover = [[UIPopoverController alloc] initWithContentViewController:dateViewController];
    [self.datePopover presentPopoverFromBarButtonItem:self.dateButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)selectTime:(id)__unused sender {
    [self dismissVisiblePopover];
    TXHTimeslotSelectorViewController *timeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Time Selector Popover"];
    timeViewController.delegate = self;
    //TODO : fix after switching to singleton [timeViewController setTimeSlots:[self.ticketingHubClient timeSlotsFor:self.selectedDate]];
    self.timePopover = [[UIPopoverController alloc] initWithContentViewController:timeViewController];
    [self.timePopover presentPopoverFromBarButtonItem:self.timeButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.navigationItem.prompt = nil;
    [self.view layoutIfNeeded];
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
    self.timeButton.enabled = (enabled && (self.selectedDate != nil));
}

- (void)resetDateAndTimeButtonLabels {
    self.dateButton.title = @"<Date>";
    self.timeButton.title = @"<Time>";
}


@end
