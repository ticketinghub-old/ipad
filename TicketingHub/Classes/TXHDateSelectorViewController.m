//
//  TXHDateSelectorViewController.m
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
#import "TXHDateSelectorViewController.h"

#import "TXHProductsManager.h"
#import "TXHTicketingHubManager.h"

#import "NSDate+CupertinoYankee.h"

#import "NSDate+Additions.h"
#import "UIColor+TicketingHub.h"


@interface TXHDateSelectorViewController ()

@property (weak, nonatomic) UIActivityIndicatorView *indicatorView;

@property (nonatomic,strong) NSArray             *dotsData;
@property (nonatomic,strong) NSMutableDictionary *dataDictionary;

@property (nonatomic,strong) NSDate *selectedDate;

@end

@implementation TXHDateSelectorViewController

#pragma mark View Lifecycle

+ (void)initialize
{
    [TKCalendarMonthView setImageTintColour:[UIColor txhDarkBlueColor]];
}

- (void) viewDidLoad
{
	[super viewDidLoad];
    
    self.dataDictionary = [NSMutableDictionary dictionary];

	[self.monthView selectDate:[NSDate date]];
}

- (void)availabilitiesUpdated:(NSNotification *)note
{
    [self.monthView reloadData];
}

#pragma mark MonthView Delegate & DataSource

- (NSArray*)calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    NSMutableSet *possibleMonthsDates = [NSMutableSet set];
    NSDate *currentMonthDate = [monthView.monthDate dateByAddingDays:1];

    // try start date - might be previous month
    [possibleMonthsDates addObject:startDate];
    // try current month
    [possibleMonthsDates addObject:currentMonthDate];
    // try las date - might be next month
    [possibleMonthsDates addObject:lastDate];
    
    
    for (NSDate *monthDate in possibleMonthsDates)
    {
        [self fetchAvailabilitiesForMonth:monthDate];
    }
    
    NSMutableArray *dotsData = [NSMutableArray array];
    
    NSDate *date = startDate;
	while(YES)
    {
        [dotsData addObject:@([[self availabilitiesForDate:date] count])];
        
		NSDateComponents *info = [date dateComponentsWithTimeZone:self.monthView.timeZone];
		info.day++;
		date = [NSDate dateWithDateComponents:info];
        
        if([date compare:lastDate] == NSOrderedDescending) break;
	}
    
    self.dotsData = [dotsData copy];
    
    return self.dotsData;
}

- (void)calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date
{
    self.selectedDate = date;
    
	[self.tableView reloadData];
}

- (void)calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated
{
	[super calendarMonthView:mv monthDidChange:d animated:animated];
	[self.tableView reloadData];
}

#pragma mark - private

- (void)fetchAvailabilitiesForMonth:(NSDate *)date
{
    NSString *monthYearKey = [date monthYearString];
    if (self.dataDictionary[monthYearKey])
        return;
    
    NSDate *startDate = [date beginningOfMonth];
    NSDate *lastDate = [date endOfMonth];
        
    //self.dotsDataDictionary[monthYearKey] = [NSMutableArray array];
    self.dataDictionary[monthYearKey] = [NSMutableDictionary dictionary];
    
    __weak typeof(self) wself = self;
    
    [TXHTICKETINHGUBCLIENT availabilitiesForProduct:[TXHPRODUCTSMANAGER selectedProduct]
                                           fromDate:startDate
                                             toDate:lastDate
                                             coupon:nil
                                         completion:^(NSArray *availabilities, NSError *error) {
                                             
                                             if (error)
                                             {
                                                 wself.dataDictionary[monthYearKey] = nil;
                                             }
                                             else
                                             {
                                                 [wself addAvailabilities:availabilities fromDate:startDate toDate:lastDate];
                                                 [wself.monthView reloadData];
                                             }
                                         }];
}

- (void)addAvailabilities:(NSArray *)availabilities fromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    NSString *monthYearKey = [startDate monthYearString];
    
    NSDate *date = startDate;
	while(YES)
    {
        NSString *dateString = [date isoDateString];

        NSIndexSet *indexes = [availabilities indexesOfObjectsWithOptions:NSEnumerationConcurrent
                                                           passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                                                               TXHAvailability *availability = (TXHAvailability *)obj;
                                                               return ([availability.dateString isEqualToString:dateString]);
                                                           }];
        
        NSArray *filteredArray = [availabilities objectsAtIndexes:indexes];
        NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateString" ascending:YES];
        NSArray * sortedArray = [filteredArray sortedArrayUsingDescriptors:@[valueDescriptor]];
        
        self.dataDictionary[monthYearKey][dateString] = sortedArray;

		NSDateComponents *info = [date dateComponentsWithTimeZone:self.monthView.timeZone];
		info.day++;
		date = [NSDate dateWithDateComponents:info];
	
        if([date compare:lastDate] == NSOrderedDescending) break;
	}
}


#pragma mark UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate *selectedDate = self.selectedDate;
	
    NSArray *availabilities = [self availabilitiesForDate:selectedDate];
    
	if(availabilities == nil) return 0;
	return [availabilities count];
}

- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    NSDate *selectedDate = self.selectedDate;
	
    NSArray *availabilities = [self availabilitiesForDate:selectedDate];
    TXHAvailability *availability = availabilities[indexPath.row];
	cell.textLabel.text = availability.timeString;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDate *selectedDate = self.selectedDate;
	
    NSArray *availabilities = [self availabilitiesForDate:selectedDate];
    TXHAvailability *availability = availabilities[indexPath.row];
    
    [self.delegate dateSelectorViewController:self didSelectAvailability:availability];
}

- (NSArray *)availabilitiesForDate:(NSDate *)date
{
    NSString *monthYearKey = [date monthYearString];
    NSString *selectedDateString = [date isoDateString];
	
    NSArray *availabilities = self.dataDictionary[monthYearKey][selectedDateString];
    
    return availabilities;
}

@end
