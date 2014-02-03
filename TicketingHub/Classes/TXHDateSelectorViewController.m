//
//  TXHDateSelectorViewController.m
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHDateSelectorViewController.h"

#import <iOS-api/iOS-api.h>

#import "TXHTicketingHubClient+AppExtension.h" // Needed for compilation - but the goal is to remove this.
#import "TXHTimeslotSelectorViewController.h" // Not really needed.

@interface TXHDateSelectorViewController () <TXHTimeSlotSelectorDelegate>

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) NSDate *previousSelectedDate;
@property (strong, nonatomic) NSArray *dateRanges;
@property (strong, nonatomic) TXHTimeslotSelectorViewController *timeSlotSelector;

@end

@implementation TXHDateSelectorViewController

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configurePickerDateRestrictions];
    // To ensure we can work out the direction of travel when scrolling to another date, start off with the picker's current date
    self.previousSelectedDate = self.datePicker.date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Superclass

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    if ([segue.identifier isEqualToString:@"Embedded Timeslots"]) {
        self.timeSlotSelector = segue.destinationViewController;
        self.timeSlotSelector.delegate = self;
    }
}

- (CGSize)contentSizeForViewInPopover {
    // Determine the size of the popover
    return CGSizeMake(self.datePicker.bounds.size.width, self.datePicker.bounds.size.height + 254.0f);
}

#pragma mark - Private

- (void)constrainToDateRanges:(NSArray *)ranges {
    self.dateRanges = ranges;
}

- (void)configurePickerDateRestrictions {
    // If we are not given any ranges; then there is nothing to do.
    if (self.dateRanges.count == 0) {
        return;
    }
    
    // Build a reference date for the start of today
    NSUInteger calendarUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:calendarUnits fromDate:[NSDate date]];
    components.hour = 0.0f;
    components.minute = 0.0f;
    components.second = 0.0f;
    NSDate *referenceDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    // OK - we're going to make an assumption here that received date ranges are in chronological order with no overlap
    NSDictionary *firstRange = [self.dateRanges firstObject];
    NSDictionary *lastRange = [self.dateRanges lastObject];
    
    // Set the outer boundaries for date selection to be between the start of the first range & the end of the last range
    NSDate *minimumDate = firstRange[@"start"];
    NSDate *maximumDate = lastRange[@"end"];
    self.datePicker.minimumDate = minimumDate;
    self.datePicker.maximumDate = maximumDate;

    // If the start date is earlier than today's date, reset minimum date to today
    NSComparisonResult result = [referenceDate compare:self.datePicker.minimumDate];
    if (result == NSOrderedDescending) {
        self.datePicker.minimumDate = referenceDate;
    }
}

- (IBAction)selectDate:(id)sender {
#pragma unused (sender)
    // Check the selected date is within any ranges provided.  If not animate moving in the direction of travel to the next available date.
    
    // If no ranges are specified, then we automatically have a valid date
    BOOL validDateFound = (self.dateRanges.count == 0);
    
    for (NSDictionary *range in self.dateRanges) {
        NSDate *start = range[@"start"];
        NSDate *end = range[@"end"];
        if (([self.datePicker.date compare:start] != NSOrderedAscending) &&
        ([self.datePicker.date compare:end] != NSOrderedDescending)) {
            validDateFound = YES;
        }
    }
    
    if (validDateFound == NO) {
        // We want to reset the date to be the nearest valid date in the direction of travel.
        
        // Work out whether we are scrolling to the future or the past
        if ([self.previousSelectedDate compare:self.datePicker.date] == NSOrderedAscending) {
            // Scrolling towards the future.  Go to the next range start.  There should be a next range as we have set the outer limits for date selection.
            for (NSDictionary *range in self.dateRanges) {
                NSDate *start = range[@"start"];
                if ([self.datePicker.date compare:start] == NSOrderedAscending) {
                    // Next start is after selected date;
                    [self.datePicker setDate:start animated:YES];
                    return;
                }
            }
        } else {
            // Scrolling towards the past.  Go to the previous range end.  There should be a previous range as we have set the outer limits for date selection.
            for (int index = self.dateRanges.count - 1; index > 0; index--) {
                NSDictionary *range = [self.dateRanges objectAtIndex:index];
                NSDate *end = range[@"end"];
                if ([self.datePicker.date compare:end] == NSOrderedDescending) {
                    // Previous range end is before selected date;
                    [self.datePicker setDate:end animated:YES];
                    return;
                }
            }
        }
        return;
    }

    // Check that we have some timeslots for the selected date
    NSArray *timeslots = [self.ticketingHubClient timeSlotsFor:self.datePicker.date];

    self.previousSelectedDate = self.datePicker.date;
    self.timeSlotSelector.timeSlots = timeslots;
}

- (void)timeSlotSelectorViewController:(TXHTimeslotSelectorViewController *)controller didSelectTime:(NSNumber *)time {
    [self.delegate dateSelectorViewController:self didSelectDate:self.datePicker.date];
    if ([self.delegate respondsToSelector:@selector(timeSlotSelectorViewController:didSelectTime:)]) {
        [self.delegate performSelector:@selector(timeSlotSelectorViewController:didSelectTime:) withObject:controller withObject:time];
    }
}

@end
