//
//  TXHMainViewController.m
//  TicketingHub
//
//  Created by Mark Brindle on 07/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMainViewController.h"
#import "TXHServerAccessManager.h"
#import "TXHCommonNames.h"
#import "TXHEmbeddingSegue.h"
#import "TXHTransitionSegue.h"
#import "TXHDateSelectorViewController.h"
#import "TXHTimeslotSelectorViewController.h"
#import "TXHVenue.h"
#import "TXHSeason.h"
#import "TXHTimeSlot.h"

@interface TXHMainViewController () <TXHDateSelectorViewDelegate, TXHTimeSlotSelectorDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl         *modeSelector;

@property (strong, nonatomic) TXHVenue                          *venue;
@property (strong, nonatomic) UIButton                          *dateBtn;
@property (strong, nonatomic) UIBarButtonItem                   *dateButton;
@property (strong, nonatomic) UIButton                          *timeBtn;
@property (strong, nonatomic) UIBarButtonItem                   *timeButton;

@property (strong, nonatomic) UIPopoverController               *datePopover;
@property (strong, nonatomic) UIPopoverController               *timePopover;

@property (strong, nonatomic) NSDate                            *selectedDate;
@property (assign, nonatomic) NSTimeInterval                    selectedTime;
@property (assign, nonatomic) BOOL                              timeSelected;

@end

@implementation TXHMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(venueUpdated:) name:NOTIFICATION_VENUE_UPDATED object:nil];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:1.0f / 255.0f green:46.0f / 255.0f blue:67.0f / 255.0f alpha:1.0f]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:24.0f],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    NSString *titleString = @"<Date>";
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    NSDictionary *attributesDict = @{NSFontAttributeName : font};
    NSAttributedString *attributedTitleString = [[NSAttributedString alloc] initWithString:titleString attributes:attributesDict];
    CGSize titleSize = [attributedTitleString size];
    //  UIImage *buttonBackgroundImage = [[UIImage imageNamed:@"ButtonBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)];
    self.dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectZero;
    frame.size = titleSize;
    self.dateBtn.frame = CGRectInset(frame, -5, -5);
    //  [dateBtn setImage:buttonBackgroundImage forState:UIControlStateNormal];
    //  [dateBtn setImage:buttonBackgroundImage forState:UIControlStateSelected];
    [self.dateBtn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    self.dateBtn.titleLabel.font = font;
    [self.dateBtn setTitle:titleString forState:UIControlStateNormal];
    self.dateBtn.tintColor = [UIColor whiteColor];
    
    self.dateButton = [[UIBarButtonItem alloc] initWithCustomView:self.dateBtn];
    
    titleString = @"<Time>";
    NSAttributedString *attributedTimeString = [[NSAttributedString alloc] initWithString:titleString attributes:attributesDict];
    CGSize timeSize = [attributedTimeString size];
    self.timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //  [timeBtn setImage:buttonBackgroundImage forState:UIControlStateNormal];
    //  [timeBtn setImage:buttonBackgroundImage forState:UIControlStateSelected];
    [self.timeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    frame.size = timeSize;
    self.timeBtn.frame = CGRectInset(frame, -5, -5);
    self.timeBtn.titleLabel.font = font;
    self.timeBtn.tintColor = [UIColor whiteColor];
    [self.timeBtn setTitle:titleString forState:UIControlStateNormal];
    
    self.timeButton = [[UIBarButtonItem alloc] initWithCustomView:self.timeBtn];
    [self.navigationItem setLeftBarButtonItems:@[self.navigationItem.leftBarButtonItem, self.dateButton, self.timeButton]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSegueWithIdentifier:@"Embed Placeholder" sender:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateControlsForUserInteraction];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleMenu:(id)sender {
#pragma unused (sender)
    [self dismissVisiblePopover];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOGGLE_MENU object:nil];
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

-(void)selectDate:(id)sender {
#pragma unused (sender)
    [self dismissVisiblePopover];

    // Build start/end ranges from all the seasons available for this venue
    NSMutableArray *ranges = [NSMutableArray array];
    for (TXHSeason *season in self.venue.allSeasons) {
        // Add a range for each season
        [ranges addObject:@{@"start": season.startsOn, @"end": season.endsOn}];
    }
    TXHDateSelectorViewController *dateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Date Selector Popover"];
    dateViewController.delegate = self;
    [dateViewController constrainToDateRanges:ranges];
    
    self.datePopover = [[UIPopoverController alloc] initWithContentViewController:dateViewController];
    [self.datePopover presentPopoverFromBarButtonItem:self.dateButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [self.view layoutIfNeeded];
}

-(void)selectTime:(id)sender {
#pragma unused (sender)
    [self dismissVisiblePopover];
    TXHTimeslotSelectorViewController *timeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Time Selector Popover"];
    timeViewController.delegate = self;
    [timeViewController setTimeSlots:[[TXHServerAccessManager sharedInstance] timeSlotsFor:self.selectedDate]];
    self.timePopover = [[UIPopoverController alloc] initWithContentViewController:timeViewController];
    [self.timePopover presentPopoverFromBarButtonItem:self.timeButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.navigationItem.prompt = nil;
    [self.view layoutIfNeeded];
}

- (IBAction)selectMode:(id)sender {
#pragma unused (sender)
    [self dismissVisiblePopover];
    if (self.modeSelector.selectedSegmentIndex == 1) {
        [self performSegueWithIdentifier:@"Flip to Doorman" sender:self];
    } else {
        [self performSegueWithIdentifier:@"Flip to Salesman" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    if ([segue isMemberOfClass:[TXHEmbeddingSegue class]])
    {
        TXHEmbeddingSegue *embeddingSegue = (TXHEmbeddingSegue *) segue;
        
        embeddingSegue.containerView = self.view;
        
        return;
    }
    
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

- (void)updateControlsForUserInteraction {
    BOOL enabled = (self.venue != nil);
    self.modeSelector.userInteractionEnabled = enabled;
    self.dateButton.enabled = enabled;
    self.timeButton.enabled = (enabled && (self.selectedDate != nil));
}


#pragma mark - TXHDateSelectorViewController delegate methods

- (void)dateSelectorViewController:(TXHDateSelectorViewController *)controller didSelectDate:(NSDate *)date {
#pragma unused (controller)
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

- (void)timeSlotSelectorViewController:(TXHTimeslotSelectorViewController *)controller didSelectTime:(NSTimeInterval)time {
#pragma unused (controller)
    self.selectedTime = time;
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
}

#pragma mark - Notifications

- (void)venueUpdated:(NSNotification *)notification {
    // Check for venue details then close menu if appropriate
    self.venue = [notification object];
    if (self.venue != nil) {
        // Display the selected venue in the navigation bar
        self.title = self.venue.businessName;
        
        // Get the current season for this venue if there is one
        TXHSeason *season = self.venue.currentSeason;
        if (season == nil) {
            self.navigationItem.prompt = NSLocalizedString(@"There are no dates for this venue", @"There are no dates for this venue");
            return;
        }
        self.navigationItem.prompt = nil;
        
        // Update our date picker barbutton control
        // Choose today, or the start of the season if it's later than today.
        NSDate *startDate = [NSDate date];
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
    self.selectedDate = nil;
    [self updateControlsForUserInteraction];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOGGLE_MENU object:nil];
}

@end
