//
//  TXHDateSelectorViewController.m
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

NSString * const DateSelectorViewControllerStoryboardIdentifier = @"DateSelectorViewController";

#import "TXHDateSelectorViewController.h"

#import <iOS-api/iOS-api.h>
#import <TimesSquare/TimesSquare.h>

@interface TXHDateSelectorViewController ()

@property (weak, nonatomic) TSQCalendarView *calendarView;

@end

@implementation TXHDateSelectorViewController

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupCalendarViewAsSubview];
}

- (void)viewDidLayoutSubviews {
    // Set the calendar view to show today date on start
    [(TSQCalendarView *)self.calendarView scrollToDate:[NSDate date] animated:NO];
}

#pragma mark - Private

- (void)setupCalendarViewAsSubview {
    TSQCalendarView *calendarView = [[TSQCalendarView alloc] init];
    calendarView.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendarView.calendar.locale = [NSLocale currentLocale];

    // Hard coded one month for development.
    calendarView.firstDate = [NSDate date];
    calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24 * 30];

    [self.view addSubview:calendarView];

    calendarView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(calendarView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[calendarView]|" options:kNilOptions metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[calendarView]|" options:kNilOptions metrics:nil views:viewsDictionary]];

    self.calendarView = calendarView;
}

@end
