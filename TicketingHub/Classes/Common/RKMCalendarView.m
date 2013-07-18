//
//  RKMCalendarView.m
//  Timecards
//
//  Created by Mark Brindle on 02/12/2011.
//  Copyright (c) 2011 ARKEMM Software Limited. All rights reserved.
//

#import "RKMCalendarView.h"

#pragma mark - Day

@interface RKMDayView : UIView {
@private
  UILabel     *dayLabel;
  UIImageView *selectedDateImageView;
  UIImageView *contentImageView;
}

@property (strong, nonatomic) NSDate  *date;
@property (assign, nonatomic) BOOL    isInCurrentMonth;
@property (assign, nonatomic) BOOL    isSelected;
@property (assign, nonatomic) BOOL    isToday;
@property (assign, nonatomic) BOOL    hasContent;

- (void)update;

@end

@implementation RKMDayView

@synthesize date = theDate;
@synthesize isInCurrentMonth = inCurrentMonth;
@synthesize isSelected = selectedImageView;
@synthesize isToday = today;
@synthesize hasContent = hasSomeContent;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    selectedDateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"firework.png"]];
    [self addSubview:selectedDateImageView];
    dayLabel = [[UILabel alloc] initWithFrame:frame];
    UIViewAutoresizing resizing = UIViewAutoresizingFlexibleWidth;
    resizing = resizing | UIViewAutoresizingFlexibleHeight;
    [dayLabel setAutoresizingMask:resizing];
    [dayLabel setTextAlignment:NSTextAlignmentCenter];
    [dayLabel setAdjustsFontSizeToFitWidth:YES];
    [dayLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:dayLabel];
    contentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recordingon.png"]];
    [contentImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:contentImageView];
    [self setBackgroundColor:[UIColor lightGrayColor]];
  }
  return self;
}

- (void)setDate:(NSDate *)date {
  theDate = date;
  static NSDateFormatter *dayFormatter = nil;
  if (dayFormatter == nil) {
    dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat: @"d"];
  }
  [dayLabel setText:[dayFormatter stringFromDate:date]];
  [self setIsSelected:NO];
  [self update];
}

- (void)setIsInCurrentMonth:(BOOL)isInCurrentMonth {
  inCurrentMonth = isInCurrentMonth;
  [self update];
}

- (void)setIsSelected:(BOOL)isSelected {
  selectedImageView = isSelected;
  [selectedDateImageView setHidden:!isSelected];
  [self update];
}

- (void)setIsToday:(BOOL)isToday {
  today = isToday;
  [self update];
}

- (void)setHasContent:(BOOL)hasContent {
  hasSomeContent = hasContent;
  [self update];
}

- (void)update {
  [self setBackgroundColor:[UIColor lightGrayColor]];
  // If we are in the current month then display dark text (unless this is today).
  if ([self isInCurrentMonth]) {
    if ([self isToday]) {
      [dayLabel setTextColor:[UIColor whiteColor]];
    } else {
      if (self.hasContent) {
        [dayLabel setTextColor:[UIColor darkTextColor]];
      } else {
        [dayLabel setTextColor:[UIColor colorWithRed:250.0f / 255.0f
                                               green:42.0f / 255.0f
                                                blue:42.0f / 255.0f
                                               alpha:1.0f]];
      }
    }
  } else {
    [dayLabel setTextColor:[UIColor lightTextColor]];
  }
  
  // If we represent Today, use a bigger bold font and set background to blue
  if ([self isToday]) {
    [dayLabel setFont:[UIFont boldSystemFontOfSize:22.0f]];
    [dayLabel setBackgroundColor:[UIColor blueColor]];
  } else {
    [dayLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [dayLabel setBackgroundColor:[UIColor lightGrayColor]];
  }
  
  // If we are selected then set label to clear and allow image to show through
  if ([self isSelected]) {
    [dayLabel setBackgroundColor:[UIColor clearColor]];
    if ([self isToday]) {
      [self setBackgroundColor:[UIColor blueColor]];
    }
  }
  
  [contentImageView setHidden:![self hasContent]];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  if ([self hasContent]) {
    CGFloat xPos = ([self bounds].size.width / 2.0f) - 4.5f;
    CGFloat yPos = [self bounds].size.height - 11.0f;
    CGRect rect = CGRectMake(xPos, yPos, 9.0f, 9.0f);
    [contentImageView setFrame:rect];
  }
}

@end

#pragma mark - Header

@interface RKMCalendarHeaderView : UIView {
@private
  UILabel *monthLabel;
  UILabel *daysLabel;
}

@property (strong, nonatomic) NSDate *date;

@end

@implementation RKMCalendarHeaderView

@synthesize date = theDate;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    monthLabel = [[UILabel alloc] initWithFrame:frame];
    [monthLabel setTextAlignment:NSTextAlignmentCenter];
    [monthLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:monthLabel];
    daysLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [daysLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [daysLabel setTextColor:[UIColor darkTextColor]];
    [daysLabel setTextAlignment:NSTextAlignmentCenter];
    [daysLabel setBackgroundColor:[UIColor lightGrayColor]];
    NSString *spacer = @"\t\t\t\t\t\t\t\t\t\t\t";
    [daysLabel setText:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",
                        NSLocalizedString(@"Mon", @"MON"),
                        spacer,
                        NSLocalizedString(@"Tue", @"TUE"),
                        spacer,
                        NSLocalizedString(@"Wed", @"WED"),
                        spacer,
                        NSLocalizedString(@"Thu", @"THU"),
                        spacer,
                        NSLocalizedString(@"Fri", @"FRI"),
                        spacer,
                        NSLocalizedString(@"Sat", @"SAT"),
                        spacer,
                        NSLocalizedString(@"Sun", @"SUN")]];
    [self addSubview:daysLabel];
    [self setBackgroundColor:[UIColor colorWithRed:0.902f
                                             green:0.902f
                                              blue:0.902f
                                             alpha:1.0f]];
  }
  return self;
}

- (void)layoutSubviews {
  CGRect rect = [self frame];
  CGFloat height = rect.size.height;
  rect.size.height = height * 2.0f / 3.0f;
  rect.origin.y += 0.5f;
  rect.size.height -= 0.5f;
  [monthLabel setFrame:CGRectInset(rect, 1.0f, 0.5f)];
  rect.origin.y += rect.size.height;
  rect.size.height = height - rect.size.height - 1.0f;
  [daysLabel setFrame:CGRectInset(rect, 1.0f, 0.5f)];
}

- (void)setDate:(NSDate *)date {
  theDate = date;
  NSCalendar *currentCalendar = [NSCalendar currentCalendar];
  NSDateComponents *comp = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) 
                                              fromDate:date];
  NSString *monthText;
  switch ([comp month]) {
    case 1:
      monthText = NSLocalizedString(@"January", @"JANUARY");
      break;
    case 2:
      monthText = NSLocalizedString(@"February", @"FEBRUARY");
      break;
    case 3:
      monthText = NSLocalizedString(@"March", @"MARCH");
      break;
    case 4:
      monthText = NSLocalizedString(@"April", @"APRIL");
      break;
    case 5:
      monthText = NSLocalizedString(@"May", @"MAY");
      break;
    case 6:
      monthText = NSLocalizedString(@"June", @"JUNE");
      break;
    case 7:
      monthText = NSLocalizedString(@"July", @"JULY");
      break;
    case 8:
      monthText = NSLocalizedString(@"August", @"AUGUST");
      break;
    case 9:
      monthText = NSLocalizedString(@"September", @"SEPTEMBER");
      break;
    case 10:
      monthText = NSLocalizedString(@"October", @"OCTOBER");
      break;
    case 11:
      monthText = NSLocalizedString(@"November", @"NOVEMBER");
      break;
    case 12:
      monthText = NSLocalizedString(@"December", @"DECEMBER");
      break;      
    default:
      monthText = NSLocalizedString(@"Unknown", @"UNKNOWN");
      break;
  }
  [monthLabel setText:[NSString stringWithFormat:@"%@ %d", monthText, [comp year]]];
}

@end

#pragma mark - Calendar

@interface RKMCalendarView() {
  RKMCalendarHeaderView *header;
  NSMutableArray        *calendarDays;  // A 35 element array for a single month
  NSDate                *today;
  NSDate                *theSelectedDate;
  
  // Internals
  CGFloat     headerHeight;
  NSUInteger  bodyRowCount;
}

@property (strong, nonatomic) RKMDayView *selectedDay;

- (void)calculateDimensions:(CGRect)rect;
- (void)drawHeader:(CGRect)rect;
- (void)drawBody:(CGRect)rect;

- (void)initCalendar;
- (void)resetCalendarDays;

- (void)showMonth:(int)offset;

@end


@implementation RKMCalendarView

@synthesize delegate = theDelegate;
@synthesize currentDate = theCurrentDate;
@synthesize selectedDay;

- (id)initWithFrame:(CGRect)frame
{
  if (frame.size.height > frame.size.width) {
    frame.size.height = frame.size.width * 0.83333333333333f;
  }
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self initCalendar];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self initCalendar];
  }
  return self;
}

- (void)initCalendar {
  UISwipeGestureRecognizer *swipeRightRecogniser = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self 
                                                    action:@selector(handleSwipeRight:)];
  [self addGestureRecognizer:swipeRightRecogniser];
  
  UISwipeGestureRecognizer *swipeLeftRecogniser = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self 
                                                    action:@selector(handleSwipeLeft:)];
  [swipeLeftRecogniser setDirection:(UISwipeGestureRecognizerDirectionLeft)];
  [self addGestureRecognizer:swipeLeftRecogniser];
  
  UISwipeGestureRecognizer *swipeUpRecogniser = [[UISwipeGestureRecognizer alloc]
                                                   initWithTarget:self 
                                                   action:@selector(handleSwipeUp:)];
  [swipeUpRecogniser setDirection:(UISwipeGestureRecognizerDirectionUp)];
  [self addGestureRecognizer:swipeUpRecogniser];
  
  UISwipeGestureRecognizer *swipeDownRecogniser = [[UISwipeGestureRecognizer alloc]
                                                   initWithTarget:self 
                                                   action:@selector(handleSwipeDown:)];
  [swipeDownRecogniser setDirection:(UISwipeGestureRecognizerDirectionDown)];
  [self addGestureRecognizer:swipeDownRecogniser];
  
  header = [[RKMCalendarHeaderView alloc] initWithFrame:CGRectZero];
  [self addSubview:header];
  calendarDays = [NSMutableArray arrayWithCapacity:42];
  for (int i = 0; i < 42; i++) {
    RKMDayView *day = [[RKMDayView alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *tapRecogniser = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self 
                                                     action:@selector(handleTap:)];
    [day addGestureRecognizer:tapRecogniser];
    [self addSubview:day];
    [calendarDays addObject:day];
  }
  
  [self setBackgroundColor:[UIColor colorWithRed:0.902f
                                           green:0.902f
                                            blue:0.902f
                                           alpha:1.0f]];
  
  NSCalendar *currentCalendar = [NSCalendar currentCalendar];
  NSDateComponents *comp = [currentCalendar components:(NSYearCalendarUnit |
                                                        NSMonthCalendarUnit | 
                                                        NSDayCalendarUnit) 
                                              fromDate:[NSDate date]];
  [comp setHour:0];
  [comp setMinute:0];
  [comp setSecond:0];
  today = [currentCalendar dateFromComponents:comp];
  [self setCurrentDate:today];
}

- (void)setDelegate:(id<RKMCalendarViewDelegate>)delegate {
  theDelegate = delegate;
  [self resetCalendarDays];
}

- (void)setCurrentDate:(NSDate *)currentDate {
  NSCalendar *currentCalendar = [NSCalendar currentCalendar];
  NSDateComponents *comp = [currentCalendar components:(NSYearCalendarUnit |
                                                        NSMonthCalendarUnit | 
                                                        NSDayCalendarUnit) 
                                              fromDate:currentDate];
  NSDateComponents *adjustedComps = [[NSDateComponents alloc] init];
  [adjustedComps setYear:[comp year]];
  [adjustedComps setMonth:[comp month]];
  [adjustedComps setDay:[comp day]];
  [adjustedComps setHour:0];
  [adjustedComps setMinute:0];
  [adjustedComps setSecond:0];
  theCurrentDate = [currentCalendar dateFromComponents:adjustedComps];
  [header setDate:theCurrentDate];
  [self resetCalendarDays];
}

- (void)resetCalendarDays {
  // update each element in the array; based on the month for the current date.
  
  // Find on which day the first of this month falls
  NSCalendar *currentCalendar = [NSCalendar currentCalendar];
  NSDateComponents *comp = [currentCalendar components:(NSYearCalendarUnit |
                                                        NSMonthCalendarUnit | 
                                                        NSDayCalendarUnit) 
                                              fromDate:[self currentDate]];
  NSDateComponents *firstComps = [[NSDateComponents alloc] init];
  [firstComps setYear:[comp year]];
  [firstComps setMonth:[comp month]];
  [firstComps setDay:1];
  NSDate *firstDayOfMonthDate = [currentCalendar dateFromComponents:firstComps];
  firstComps = [currentCalendar components:(NSYearCalendarUnit |
                                            NSMonthCalendarUnit | 
                                            NSDayCalendarUnit | 
                                            NSWeekOfMonthCalendarUnit) 
                                  fromDate:firstDayOfMonthDate];

  // Get the last day of this month, by adding a month & going back a day
  NSDateComponents *lastDayComps = [[NSDateComponents alloc] init];
  [lastDayComps setMonth:1];
  [lastDayComps setDay:-1];
  NSDate *lastDayOfMonthDate = [currentCalendar dateByAddingComponents:lastDayComps
                                                                toDate:firstDayOfMonthDate
                                                               options:0];
  lastDayComps = [currentCalendar components:(NSYearCalendarUnit |
                                              NSMonthCalendarUnit | 
                                              NSDayCalendarUnit |
                                              NSWeekOfMonthCalendarUnit) 
                                    fromDate:lastDayOfMonthDate];

  // Get the weekday for the first date (1 == Sun, 2 == Mon ... 7 == Sat)
  comp = [currentCalendar components:(NSWeekdayCalendarUnit) fromDate:firstDayOfMonthDate];
  NSInteger offset = [comp weekday];
  
  // Get the first date to display
  offset -= 2;
  if (offset < 0) {
    offset = 6;
  }
  NSDateComponents *offsetComp = [[NSDateComponents alloc] init];
  [offsetComp setDay:-offset];
  NSDate *dateToDisplay = [currentCalendar dateByAddingComponents:offsetComp
                                                           toDate:firstDayOfMonthDate
                                                          options:0];
  // Adjust body row count for positioning
  bodyRowCount = 5;
  switch (offset) {
    case 6:
      if ([lastDayComps day] > 29) {
        bodyRowCount = 6;
      }
      break;
    case 5:
      if ([lastDayComps day] > 30) {
        bodyRowCount = 6;
      }
      break;
    case 0:
      if ([lastDayComps day] == 28) {
        bodyRowCount = 4;
      }
      break;
    default:
      break;
  }
  

   BOOL inCurrentMonth;
  [offsetComp setDay:1];
  // Now we can update each element of the array
  int dayIndex = 0;
  for (RKMDayView *dayView in calendarDays) {
    [dayView setDate:dateToDisplay];
    if ([[self delegate] respondsToSelector:@selector(hasContentForDate:)]) {
      [dayView setHasContent:[[self delegate] hasContentForDate:dateToDisplay]];
    } else {
      [dayView setHasContent:NO];
    }
    inCurrentMonth = !(([dateToDisplay compare:firstDayOfMonthDate] == NSOrderedAscending) || ([dateToDisplay compare:lastDayOfMonthDate] == NSOrderedDescending));
    [dayView setIsInCurrentMonth:inCurrentMonth];
    [dayView setIsToday:[dateToDisplay isEqualToDate:today]];
    [dayView setIsSelected:[dateToDisplay isEqualToDate:theSelectedDate]];
    dateToDisplay = [currentCalendar dateByAddingComponents:offsetComp
                                                     toDate:dateToDisplay
                                                    options:0];
    dayIndex++;
  }
  [self setNeedsLayout];
}

- (void)layoutSubviews {
  // Resize everything in last row to zero in case it isn't needed
  for (int i = 35; i < 42; i++) {
    [(RKMDayView *)[calendarDays objectAtIndex:i] setFrame:CGRectZero];
  }
  // Amend the height of headerView dependent upon the number of rows to display
  CGFloat rowHeight = [self frame].size.height / (bodyRowCount + 1);
  CGFloat rowWidth = ([self frame].size.width / 7.0f);
  headerHeight = [self frame].size.height - (rowHeight * bodyRowCount);
  CGRect rect = CGRectMake([self frame].origin.x, [self frame].origin.y, [self frame].size.width, headerHeight);
  [header setFrame:rect];
  // body view
  rect.size.height = rowHeight - 1.0f;
  rect.size.width = rowWidth - 1.0f;
  int dayIndex = 0;
  CGFloat xPos = [self frame].origin.x;
  CGFloat yPos = headerHeight;
  for (int row = 0; row < bodyRowCount; row++) {
    for (int col = 0; col < 7; col++) {
      RKMDayView *view = (RKMDayView *)[calendarDays objectAtIndex:dayIndex];
      rect.origin.x = xPos;
      rect.origin.y = yPos;
      [view setFrame:rect];
      dayIndex++;
      xPos += rowWidth;
    }
    xPos = [self frame].origin.x;
    yPos += rowHeight;
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  // Draw the header block, which covers the full width & either 1/5 or 1/6th height
  [self calculateDimensions:rect];
  
  CGRect headerRect = CGRectMake(rect.origin.x, 
                                 rect.origin.y, 
                                 rect.size.width, 
                                 headerHeight);
  [self drawHeader:headerRect];
  
  // Draw the date block
  CGRect bodyRect = CGRectMake(rect.origin.x,
                               rect.origin.y + headerHeight,
                               rect.size.width,
                               rect.size.height - headerHeight);
  [self drawBody:bodyRect];
}
*/

- (void)calculateDimensions:(CGRect)rect {
#pragma unused (rect)
}

- (void)drawHeader:(CGRect)rect {
#pragma unused (rect)
}

- (void)drawBody:(CGRect)rect {
#pragma unused (rect)
}

- (void)selectDate:(NSDate *)date {
  NSCalendar *currentCalendar = [NSCalendar currentCalendar];
  NSDateComponents *comp = [currentCalendar components:(NSYearCalendarUnit |
                                                        NSMonthCalendarUnit | 
                                                        NSDayCalendarUnit) 
                                              fromDate:date];
  NSDateComponents *adjustedComps = [[NSDateComponents alloc] init];
  [adjustedComps setYear:[comp year]];
  [adjustedComps setMonth:[comp month]];
  [adjustedComps setDay:[comp day]];
  [adjustedComps setHour:0];
  [adjustedComps setMinute:0];
  [adjustedComps setSecond:0];
  NSDate *theDate = [currentCalendar dateFromComponents:adjustedComps];
  
  BOOL canSelectDate = YES;
  if ([[self delegate] respondsToSelector:@selector(willSelectDate:)]) {
    canSelectDate = [[self delegate] willSelectDate:theDate];
  }
  if (canSelectDate) {
    if ([self selectedDay] != nil) {
      [[self selectedDay] setIsSelected:NO];
    }
    [self setCurrentDate:theDate];
    theSelectedDate = [self currentDate];
    for (RKMDayView *day in calendarDays) {
      if ([[day date] isEqualToDate:[self currentDate]]) {
        [day setIsSelected:YES];
        [self setSelectedDay:day]; 
        break;
      }
    }
    [self resetCalendarDays];
    if ([[self delegate] respondsToSelector:@selector(didSelectDate:)]) {
      [[self delegate] didSelectDate:[self currentDate]];
    }
  }
}

#pragma mark - Gesture handlers

- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer {
  RKMDayView *day = (RKMDayView *)[recognizer view];
  BOOL canSelectDate = YES;
  if ([[self delegate] respondsToSelector:@selector(willSelectDate:)]) {
    canSelectDate = [[self delegate] willSelectDate:[day date]];
  }
  if (canSelectDate) {
    if ([self selectedDay] != nil) {
      [[self selectedDay] setIsSelected:NO];
    }
    [day setIsSelected:!(day == [self selectedDay])];
    if ([day isSelected]) {
      [self setSelectedDay:day];
      theSelectedDate = [day date];
    } else {
      [self setSelectedDay:nil];
      theSelectedDate = nil;
    }
    if ([[self delegate] respondsToSelector:@selector(didSelectDate:)]) {
      [[self delegate] didSelectDate:[day date]];
    }
  }
}

- (IBAction)handleSwipeUp:(UISwipeGestureRecognizer *)recognizer {
#pragma unused (recognizer)
  [self showMonth:+12];
}

- (IBAction)handleSwipeDown:(UISwipeGestureRecognizer *)recognizer {
#pragma unused (recognizer)
  [self showMonth:-12];
}

- (IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer {
#pragma unused (recognizer)
  [self showMonth:+1];
}

- (IBAction)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer {
#pragma unused (recognizer)
  [self showMonth:-1];
}

- (void)showMonth:(int)offset {
  NSCalendar *currentCalendar = [NSCalendar currentCalendar];
  NSDateComponents *comp = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[self currentDate]];
  [comp setMonth:[comp month] + offset];
  [self setCurrentDate:[currentCalendar dateFromComponents:comp]];  
}

@end
