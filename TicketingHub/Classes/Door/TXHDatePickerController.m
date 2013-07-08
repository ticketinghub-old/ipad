//
//  TXHDatePickerController.m
//  TicketingHub
//
//  Created by Mark on 18/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHDatePickerController.h"
#import "TXHCommonNames.h"
#import "RKMCalendarView.h"

@interface TXHDatePickerController () <RKMCalendarViewDelegate>

@property (weak, nonatomic) IBOutlet RKMCalendarView *calendar;

@end

@implementation TXHDatePickerController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateChanged:(id)sender {
#pragma unused (sender)
  [[NSNotificationCenter defaultCenter] postNotificationName:doorDateSelected object:self.datePicker.date];
}

- (BOOL)hasContentForDate:(NSDate *)date {
  NSUInteger index = [self.availableDates indexOfObject:date];
  BOOL hasContent = (index != NSNotFound);
  return hasContent;
}

- (BOOL)willSelectDate:(NSDate *)date {
  NSUInteger index = [self.availableDates indexOfObject:date];
  BOOL hasContent = (index != NSNotFound);
  return hasContent;
}

- (void)didSelectDate:(NSDate *)date {
  [[NSNotificationCenter defaultCenter] postNotificationName:doorDateSelected object:date];
}

@end
