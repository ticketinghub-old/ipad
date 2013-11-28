//
//  SalesOrDoormanViewController.m
//  TicketingHub
//
//  Created by Mark Brindle on 07/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "SalesOrDoormanViewController.h"
@import CoreData;

#import "TXHDateSelectorViewController.h"
#import "TXHEmbeddingSegue.h"
#import "TXHSeason_old.h"
#import "TXHServerAccessManager.h"
#import "TXHTicketDetail.h"
#import "TXHTicketTier.h"
#import "TXHTimeSlot_old.h"
#import "TXHTimeslotSelectorViewController.h"
#import "TXHTransitionSegue.h"
#import "TXHVenueMO.h"
#import "ProductListControllerNotifications.h"

@interface SalesOrDoormanViewController () <TXHDateSelectorViewDelegate, TXHTimeSlotSelectorDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UIView *contentDetailView;

@property (strong, nonatomic) TXHVenue                          *venue;   // Kill this
@property (strong, nonatomic) UIButton                          *dateBtn; // Kill this
@property (strong, nonatomic) UIButton                          *timeBtn; // Kill this
@property (strong, nonatomic) UIBarButtonItem                   *dateButton;
@property (strong, nonatomic) UIBarButtonItem                   *timeButton;

@property (strong, nonatomic) UIPopoverController               *datePopover;
@property (strong, nonatomic) UIPopoverController               *timePopover;

@property (strong, nonatomic) NSDate                            *selectedDate;
@property (assign, nonatomic) NSTimeInterval                    selectedTime;
@property (assign, nonatomic) BOOL                              timeSelected;

@end

@implementation SalesOrDoormanViewController

#pragma mark - View Lifecycle

//- (void)setup_old {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(venueUpdated:) name:NOTIFICATION_VENUE_UPDATED object:nil];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:38.0f / 255.0f
//                                                                             green:65.0f / 255.0f
//                                                                              blue:87.0f / 255.0f
//                                                                             alpha:1.0f]];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:24.0f],
//                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]};
//
//    NSString *titleString = @"<Date>";
//    UIFont *font = [UIFont systemFontOfSize:15.0f];
//    NSDictionary *attributesDict = @{NSFontAttributeName : font};
//    NSAttributedString *attributedTitleString = [[NSAttributedString alloc] initWithString:titleString attributes:attributesDict];
//    CGSize titleSize = [attributedTitleString size];
//    //  UIImage *buttonBackgroundImage = [[UIImage imageNamed:@"ButtonBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)];
//    self.dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    CGRect frame = CGRectZero;
//    frame.size = titleSize;
//    self.dateBtn.frame = CGRectInset(frame, -5, -5);
//    //  [dateBtn setImage:buttonBackgroundImage forState:UIControlStateNormal];
//    //  [dateBtn setImage:buttonBackgroundImage forState:UIControlStateSelected];
//    [self.dateBtn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
//    self.dateBtn.titleLabel.font = font;
//    [self.dateBtn setTitle:titleString forState:UIControlStateNormal];
//    self.dateBtn.tintColor = [UIColor whiteColor];
//
//    self.dateButton = [[UIBarButtonItem alloc] initWithCustomView:self.dateBtn];
//
//    titleString = @"<Time>";
//    NSAttributedString *attributedTimeString = [[NSAttributedString alloc] initWithString:titleString attributes:attributesDict];
//    CGSize timeSize = [attributedTimeString size];
//    self.timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    //  [timeBtn setImage:buttonBackgroundImage forState:UIControlStateNormal];
//    //  [timeBtn setImage:buttonBackgroundImage forState:UIControlStateSelected];
//    [self.timeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
//    frame.size = timeSize;
//    self.timeBtn.frame = CGRectInset(frame, -5, -5);
//    self.timeBtn.titleLabel.font = font;
//    self.timeBtn.tintColor = [UIColor whiteColor];
//    [self.timeBtn setTitle:titleString forState:UIControlStateNormal];
//
//    UIBarButtonItem *handleItem = self.navigationItem.leftBarButtonItem;
//
//    handleItem.tintColor = [UIColor colorWithRed:188.0f / 255.0f
//                                           green:207.0f / 255.0f
//                                            blue:219.0f / 255.0f
//                                           alpha:1.0f];
//
//    self.timeButton = [[UIBarButtonItem alloc] initWithCustomView:self.timeBtn];
//    [self.navigationItem setLeftBarButtonItems:@[self.navigationItem.leftBarButtonItem, self.dateButton, self.timeButton]];
//}

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
    //    if ([segue isMemberOfClass:[TXHTransitionSegue class]]) {
    //        TXHTransitionSegue *transitionSegue = (TXHTransitionSegue *)segue;
    //
    //        transitionSegue.containerView = self.view;
    //
    //        if ([segue.identifier isEqualToString:@"Flip To Salesman"]) {
    //            transitionSegue.animationOptions = UIViewAnimationOptionTransitionCurlDown;
    //        }
    //        else
    //        {
    //            transitionSegue.animationOptions = UIViewAnimationOptionTransitionCurlUp;
    //        }
    //    }
}

#pragma mark Public

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

- (void)setSelectedVenue:(TXHVenueMO *)selectedVenue {
    _selectedVenue = selectedVenue;

    // More stuff needed here to reset the UI if the view is loaded
    if ([self isViewLoaded]) {
        [self resetDateAndTimeButtons];
    }
}

#pragma mark - Notification handlers

- (void)productChanged:(NSNotification *)notification {
    self.selectedVenue = [notification userInfo][TXHSelectedVenue];
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
    [self.dateBtn setTitle:[dateFormatter stringFromDate:self.selectedDate] forState:UIControlStateNormal];
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
    [self.timeBtn setTitle:[timeFormatter stringFromDate:dateAndTime] forState:UIControlStateNormal];
    [self.timeBtn sizeToFit];
    [self.timePopover dismissPopoverAnimated:YES];
    [self updateControlsForUserInteraction];
    [[TXHServerAccessManager sharedInstance] getTicketOptionsForTimeSlot:time
                                                       completionHandler:^(TXHTicketDetail *detail){
#pragma unused (detail)
                                                       }
                                                            errorHandler:^(id reason){
                                                                NSLog(@"ticket detail error: %@", reason);
                                                            }];
}

#pragma mark - Notifications

- (void)venueUpdated:(NSNotification *)notification {
    // Check for venue details then close menu if appropriate
    NSDate *startDate = [NSDate date];
    self.venue = [notification object];
    if (self.venue != nil) {
        // Display the selected venue in the navigation bar
#warning - AN turned this off!
        //        self.title = self.venue.businessName;
        self.title = @"Hello!";

        // Get the first season for this venue if there is one
#warning - AN turned this off!
        //        TXHSeason_old *season = [self.venue.allSeasons firstObject];
        TXHSeason_old *season = nil;
        if (season == nil) {
            self.navigationItem.prompt = NSLocalizedString(@"There are no dates for this venue", @"There are no dates for this venue");
            return;
        }
        self.navigationItem.prompt = nil;

        // Update our date picker barbutton control to show the date
        // Choose today, or the start of the season if it's later than today.
        NSDate *seasonStart = season.startsOn;
        if ([startDate compare:seasonStart] == NSOrderedAscending) {
            startDate = seasonStart;
        }
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            dateFormatter.timeStyle = NSDateFormatterNoStyle;
        }
        NSString *dateString = [dateFormatter stringFromDate:startDate];
        [self.dateBtn setTitle:dateString forState:UIControlStateNormal];
        [self.dateBtn sizeToFit];
    }
    self.selectedDate = startDate;
    [self updateControlsForUserInteraction];
    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOGGLE_MENU object:nil];
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

    // Build start/end ranges from all the seasons available for this venue
    NSMutableArray *ranges = [NSMutableArray array];
#warning - AN turned this off!
    //    for (TXHSeason_old *season in self.venue.allSeasons) {
    //        // Add a range for each season
    //        [ranges addObject:@{@"start": season.startsOn, @"end": season.endsOn}];
    //    }
    // - commented this section out
    TXHDateSelectorViewController *dateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Date Selector Popover"];
    dateViewController.delegate = self;
    [dateViewController constrainToDateRanges:ranges];

    [self.view layoutIfNeeded];

    self.datePopover = [[UIPopoverController alloc] initWithContentViewController:dateViewController];
    [self.datePopover presentPopoverFromBarButtonItem:self.dateButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)selectTime:(id)__unused sender {
    [self dismissVisiblePopover];
    TXHTimeslotSelectorViewController *timeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Time Selector Popover"];
    timeViewController.delegate = self;
    [timeViewController setTimeSlots:[[TXHServerAccessManager sharedInstance] timeSlotsFor:self.selectedDate]];
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
    BOOL enabled = (self.venue != nil);
    //    self.modeSelector.userInteractionEnabled = enabled;
    self.dateButton.enabled = enabled;
    self.timeButton.enabled = (enabled && (self.selectedDate != nil));
}

// Resets the date and time buttons to when changing venue
- (void)resetDateAndTimeButtons {
    self.dateButton.title = @"<Reset Date>";
    self.timeButton.title = @"<Reset Time>";
}


@end
