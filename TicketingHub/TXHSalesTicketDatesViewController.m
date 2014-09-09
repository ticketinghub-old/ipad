//
//  TXHSalesTicketDatesViewController.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHSalesTicketDatesViewController.h"
#import "TXHEventCollectionViewCell.h"
#import "TXHEventHeaderView.h"

#import "TXHOrderManager.h"
#import "TXHProductsManager.h"

#import <iOS-api/NSDate+ISO.h>
#import "NSDate+CupertinoYankee.h"
#import "NSDate+Additions.h"
#import <thcal/CALView.h>

#import "TXHActivityLabelView.h"
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>
#import <CoreLocation/CoreLocation.h>


@interface TXHSalesTicketDatesViewController () <CALViewDataSource, CALViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate>

@property (readwrite, assign, nonatomic, getter = isValid) BOOL valid;
@property (readwrite, assign, nonatomic) BOOL shouldBeSkiped;

@property (weak, nonatomic) IBOutlet CALView *callendarView;
@property (weak, nonatomic) IBOutlet UICollectionView *eventsCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) TXHActivityLabelView *datesActivityView;
@property (strong, nonatomic) TXHActivityLabelView *dayTimesActivityView;
@property (strong, nonatomic) TXHActivityLabelView *activityView;


@property (strong, nonatomic) NSMutableSet *availableDates;
@property (strong, nonatomic) NSArray *availabilities;
@property (strong, nonatomic, readonly) NSArray *availabilitiesGroupedByHours;

@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) TXHAvailability *selectedAvailability;


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation TXHSalesTicketDatesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBottomInset];
    
    [self loadDates];
    
    [self updateView];
}

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager)
    {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager = locationManager;
    }
    return _locationManager;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.callendarView scrollToCurrentMonth:NO];
}

- (void)updateView
{
    self.eventsCollectionView.hidden = self.selectedDate == nil || ![self.availabilities count];
    
    if (!self.selectedDate)
        self.infoLabel.text = NSLocalizedString(@"SALESMAN_DATES_SELCT_DATE_MESSAGE", nil);
    else if (self.availabilities && ![self.availabilities count])
        self.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"SALESMAN_DATES_NO_AVAILABLE_TIMES_MESSAGE_FORMAT", nil),[self stringfromdate:self.selectedDate]];
    else
        self.infoLabel.text = nil;
}

- (void)loadDates
{
    __weak typeof(self) wself = self;
    
    // TODO: cahnge those to fire when scrolling for visible dates maybe...

    [self.datesActivityView showWithMessage:NSLocalizedString(@"SALESMAN_DATES_LOADING_AVAILABLE_DATES_MESSAGE", nil)
                            indicatorHidden:NO];
    
    [self.productManager availableDatesFrom:[self startDate]
                                    endDate:[self endDate]
                                 completion:^(NSArray *availableDates, NSError *error) {
                                     [wself.datesActivityView hide];
                                     
                                     [wself.availableDates addObjectsFromArray:availableDates];
                                     [wself reloadCallendar];
                                     [wself.callendarView selectDateIfAvailable:[NSDate date]];
                                 }];
}

- (void)setBottomInset
{
    UIEdgeInsets bottomInset = UIEdgeInsetsMake(0, 0, 105, 0);
    
    [self.callendarView setContentInset:bottomInset];
    [self.eventsCollectionView setContentInset:bottomInset];
}

- (NSMutableSet *)availableDates
{
    if (!_availableDates)
        _availableDates = [NSMutableSet set];
    return _availableDates;
}

- (void)setAvailabilities:(NSArray *)availabilities
{
    _availabilities = availabilities;
    _availabilitiesGroupedByHours = [self groupAvailabilitiesIntoHours:availabilities];
    
    [self updateView];
    [self.eventsCollectionView reloadData];
}

- (NSArray *)groupAvailabilitiesIntoHours:(NSArray *)availabilities
{
    if (!availabilities || !availabilities.count)
    {
        _availabilitiesGroupedByHours = nil;
        return nil;
    }
    NSMutableArray * availabilitiesIntoHours = [NSMutableArray array];
    NSMutableArray * currentHourArray = [NSMutableArray array];
    NSString * prevHour = nil;
    for (TXHAvailability * availability in self.availabilities ) {
        NSArray * timeArray = [availability.timeString componentsSeparatedByString:@":"];
        if (!prevHour) prevHour = timeArray.firstObject;
        if (![prevHour isEqualToString:timeArray.firstObject])
        {
            [availabilitiesIntoHours addObject:[currentHourArray copy]];
            currentHourArray = [NSMutableArray array];
        }
        [currentHourArray addObject:availability];
    }
    [availabilitiesIntoHours addObject:[currentHourArray copy]];
    return [availabilitiesIntoHours copy];
}

- (void)setSelectedAvailability:(TXHAvailability *)selectedAvailability
{
    _selectedAvailability = selectedAvailability;
    _selectedAvailability.dateString = [self.selectedDate isoDateString];
    _selectedAvailability.product = self.productManager.selectedProduct;
    
    self.valid = selectedAvailability != nil;
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
    
    [self updateView];
}

- (TXHActivityLabelView *)datesActivityView
{
    if (!_datesActivityView)
        _datesActivityView = [TXHActivityLabelView getInstanceInView:self.callendarView];
    return _datesActivityView;
}

- (TXHActivityLabelView *)dayTimesActivityView
{
    if (!_dayTimesActivityView)
        _dayTimesActivityView = [TXHActivityLabelView getInstanceInView:self.eventsCollectionView];
    return _dayTimesActivityView;
}

- (TXHActivityLabelView *)activityView
{
    if (!_activityView)
        _activityView = [TXHActivityLabelView getInstanceInView:self.view];
    return _activityView;
}

- (void)reloadCallendar
{
    [self.callendarView reloadData];
}

#pragma mark CALViewDelegate

- (void)dateSelected:(NSDate *)date
{
    self.availabilities = nil;

    self.selectedDate = date;
    
    __weak typeof(self) wself = self;
    
    
    
    [self.dayTimesActivityView showWithMessage:NSLocalizedString(@"SALESMAN_DATES_LOADING_AVAILABLE_DAYTIMES_MESSAGE", nil)
                               indicatorHidden:NO];
    
    [self.productManager availabilitiesForISODate:[date isoDateString]
                                          tickets:[self selectedTicketQuantities]
                                       couponCode:self.orderManager.coupon.code
                                       completion:^(NSArray *availabilities, NSError *error) {
                                           [wself.dayTimesActivityView hide];
                                           wself.availabilities = availabilities;
                                       }];
}

// TODO bit of the mes beacuse of those internal id's, damn backed....
- (NSArray *)selectedTicketQuantities
{
    NSMutableArray *tiersQuantities = [NSMutableArray array];
    
    for (NSString *tierInternalID in self.orderManager.tiersQuantities)
    {
        TXHTier *tier = [TXHTier tierWithInternalID:tierInternalID inManagedObjectContext:self.productManager.selectedProduct.managedObjectContext];

        [tiersQuantities addObject:@{ @"tier" : tier.tierId,
                                      @"quantity" : self.orderManager.tiersQuantities[tierInternalID]}];
    }
    return [tiersQuantities copy];
}

- (void)eventSelected:(NSInteger)numberOfEvent date:(NSDate *)date
{

}

#pragma mark CALViewDataSource


- (NSDate *)startDate
{
    return [[NSDate date] beginningOfMonth];
}

- (NSDate *)endDate
{
    return [[[NSDate date] dateByAddingTimeInterval:60*60*24*30*24] endOfYear];
}

// optional

- (NSInteger)isDateSelectable:(NSDate *)date
{
    return [self.availableDates containsObject:[date isoDateString]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.availabilitiesGroupedByHours[section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.availabilitiesGroupedByHours count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TXHEventCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventCell" forIndexPath:indexPath];
    
    TXHAvailability *availability = [self availabilityAtIndexPath:indexPath];
    NSString *spacesString = nil;
    if (availability.limit)
        spacesString = [NSString stringWithFormat:NSLocalizedString(@"SALESMAN_DATES_TIME_SPACES_FORMAT", nil), [availability.limit integerValue]];
    
    [cell setTimeString:availability.timeString];
    [cell setSpacesString:spacesString];
    [cell setPriceString:[self.productManager priceStringForPrice:availability.total]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    TXHEventHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"EventsHeader" forIndexPath:indexPath];
    
    if (indexPath.section == 0)
        [header setTitleText:[self stringfromdate:self.selectedDate]];
    
    return header;
}

- (NSString *)stringfromdate:(NSDate *)date
{
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEE MMMM d yyyy" options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    
    return [formatter stringFromDate:date];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return CGSizeMake(0, 0);
    }else {
        return CGSizeMake(collectionView.bounds.size.width, 70);
    }
}

- (TXHAvailability *)availabilityAtIndexPath:(NSIndexPath *)indexPath
{
    return self.availabilitiesGroupedByHours[indexPath.section][indexPath.item]; // TODO: make more secure
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TXHAvailability *selectedAvailability = [self availabilityAtIndexPath:indexPath];
    self.selectedAvailability = selectedAvailability;
}

#pragma mark - TXHSalesContentsViewControllerProtocol

- (void)finishStepWithCompletion:(void (^)(NSError *error))blockName
{
    __weak typeof(self) wself = self;
    
    [self.activityView showWithMessage:NSLocalizedString(@"SALESMAN_DATES_RESERVING_TICKETS_MESSAGE", nil)
                       indicatorHidden:NO];

    [self.orderManager reserveTicketsWithAvailability:self.selectedAvailability
                                             latitude:self.currentLocation.coordinate.latitude
                                            longitude:self.currentLocation.coordinate.longitude
                                             completion:^(TXHOrder *order, NSError *error) {
                                                 [wself.activityView hide];
                                                 
                                                 if (error)
                                                 {
                                                     [self showErrorWithTitle:NSLocalizedString(@"ERROR_TITLE", nil)
                                                                      message:error.localizedDescription
                                                                       action:^{
                                                                           if (blockName)
                                                                               blockName(error);
                                                                       }];
                                                 }
                                                 else if (blockName)
                                                     blockName(nil);
                                             }];

}

#pragma mark - error helper

- (void)showErrorWithTitle:(NSString *)title message:(NSString *)message action:(void(^)(void))action
{
    [self.activityView hide];
    
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"ERROR_DISMISS_BUTTON_TITLE", nil)
                                                    action:^{
                                                        if (action)
                                                            action();
                                                    }];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                               cancelButtonItem:cancelItem
                                               otherButtonItems: nil];
    [alertView show];
}

#pragma mark CLLocationMangerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
}

@end
