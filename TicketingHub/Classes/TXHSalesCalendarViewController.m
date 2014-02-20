//
//  TXHSalesCalendarViewController.m
//  TicketingHub
//
//  Created by Mark on 15/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesCalendarViewController.h"

#import "TXHCommonNames.h"

@interface TXHSalesCalendarViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *timeIntervalTable;

@property (strong, nonatomic) NSMutableArray *timeSlots;

@end

@implementation TXHSalesCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
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
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(venueUpdated:) name:NOTIFICATION_VENUE_UPDATED object:nil];
  self.timeSlots = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.datePicker setMinimumDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)dateChanged:(id)sender {
#pragma unused (sender)
  [self getTimeSlots];
}

#pragma mark - TableView datasource & delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#pragma unused (tableView)
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#pragma unused (tableView)
#pragma unused (section)
  return self.timeSlots.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeSlotCellID" forIndexPath:indexPath];
  [self setupCell:cell forRowAtIndexPath:indexPath];
  return cell;
}

- (void)setupCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  id timeslot = [self.timeSlots objectAtIndex:indexPath.row];
  if ([timeslot respondsToSelector:@selector(title)]) {
    cell.textLabel.text = [timeslot title];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma unused (tableView)
  // Selecting a cell identified a timeslot, we need to tell the world about it
  id timeSlot = [self.timeSlots objectAtIndex:indexPath.row];
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIMESLOT_SELECTED object:timeSlot];
}

- (void)getTimeSlots {
  // Clear out any existing timeslots
  [self.timeSlots removeAllObjects];

  // Get timeslots for the currently selected date
//  NSArray *timeslots = [TXHTICKETINHGUBCLIENT timeSlotsFor:self.datePicker.date];
//  
//  if (timeslots.count > 0) {
//    [self.timeSlots addObjectsFromArray:timeslots];
//  } else {
//    NSLog(@"no timeslots for %@", self.datePicker.description);
//  }
//  
//  // Update our timezone display
//  dispatch_async(dispatch_get_main_queue(), ^{
//    [self.timeIntervalTable reloadData];
//  });
}

#pragma mark - Notifications

//- (void)venueUpdated:(NSNotification *)notification {
//  // The updated venue is passed to us in the notification
//  TXHVenue *venue = [notification object];
//  
//  // Get the current season for this venue
//#warning - AN turned this off!
////  TXHSeason *season = venue.currentSeason;
//    TXHSeason_old *season = nil;
//
//  // If there is no current season overlay a view with a warning
//  if (season == nil) {
////    NSLog(@"There is no season configured for %@", venue.businessName);
//    return;
//  }
//
//  // Get season start and end to restrict calendar date ranges
//    NSDate *startOfSeason = season.startsOn;
//    NSDate *endOfSeason = season.endsOn;
//
//    self.datePicker.minimumDate = startOfSeason;
//    self.datePicker.maximumDate = endOfSeason;
//
//  // If the currently selected date is outside of the bounds of the current season adjust accordingly
//  
//  [self getTimeSlots];
//    //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOGGLE_MENU object:nil];
//}

@end
