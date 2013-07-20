//
//  TXHMainViewController.m
//  TicketingHub
//
//  Created by Mark Brindle on 07/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHMainViewController.h"
#import "TXHCommonNames.h"
#import "TXHVenue.h"
#import "TXHServerAccessManager.h"

// UIAlertViewDelegate is ONLY FOR TESTING purposes & may be removed
@interface TXHMainViewController ()

@property (readwrite, nonatomic)  BOOL  isUserLoggedIn;

// A list of venues from which a venue can be selected
@property (strong, nonatomic) NSMutableArray  *venuesList;

@property (readwrite, nonatomic) NSInteger venueSelected;

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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(venueSelected:) name:NOTIFICATION_VENUE_SELECTED object:nil];
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:1.0f / 255.0f green:46.0f / 255.0f blue:67.0f / 255.0f alpha:1.0f]];
  self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:24.0f],
                                                                  NSForegroundColorAttributeName: [UIColor whiteColor]};
  
  NSString *titleString = @"21st Oct 2013";
  UIFont *font = [UIFont systemFontOfSize:15.0f];
  NSDictionary *attributesDict = @{NSFontAttributeName : font};
  NSAttributedString *attributedTitleString = [[NSAttributedString alloc] initWithString:titleString attributes:attributesDict];
  CGSize titleSize = [attributedTitleString size];
//  UIImage *buttonBackgroundImage = [[UIImage imageNamed:@"ButtonBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)];
  UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  CGRect frame = CGRectZero;
  frame.size = titleSize;
  dateBtn.frame = CGRectInset(frame, -5, -5);
//  [dateBtn setImage:buttonBackgroundImage forState:UIControlStateNormal];
//  [dateBtn setImage:buttonBackgroundImage forState:UIControlStateSelected];
  [dateBtn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
  dateBtn.titleLabel.font = font;
  [dateBtn setTitle:titleString forState:UIControlStateNormal];
  dateBtn.tintColor = [UIColor whiteColor];
  
  UIBarButtonItem *dateButton = [[UIBarButtonItem alloc] initWithCustomView:dateBtn];

  titleString = @"13:00";
  NSAttributedString *attributedTimeString = [[NSAttributedString alloc] initWithString:titleString attributes:attributesDict];
  CGSize timeSize = [attributedTimeString size];
  UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//  [timeBtn setImage:buttonBackgroundImage forState:UIControlStateNormal];
//  [timeBtn setImage:buttonBackgroundImage forState:UIControlStateSelected];
  [timeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
  frame.size = timeSize;
  timeBtn.frame = CGRectInset(frame, -5, -5);
  timeBtn.tintColor = [UIColor whiteColor];
  [timeBtn setTitle:titleString forState:UIControlStateNormal];
  
  UIBarButtonItem *timeButton = [[UIBarButtonItem alloc] initWithCustomView:timeBtn];
  [self.navigationItem setLeftBarButtonItems:@[self.navigationItem.leftBarButtonItem, dateButton, timeButton]];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)venuesList {
  if (_venuesList == nil) {
    _venuesList = [NSMutableArray array];
  }
  return _venuesList;
}

- (IBAction)toggleMenu:(id)sender {
#pragma unused (sender)
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOGGLE_MENU object:nil];
}

-(void)selectDate:(id)sender {
#pragma unused (sender)
  NSLog(@"Date selected");
}

-(void)selectTime:(id)sender {
#pragma unused (sender)
  NSLog(@"Time selected");
}

#pragma mark - Notifications

- (void)venueSelected:(NSNotification *)notification {
  // Check for venue details then close menu if appropriate
  TXHVenue *venue = [notification object];
  self.title = venue.businessName;
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOGGLE_MENU object:nil];
}

@end
