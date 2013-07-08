//
//  TXHDoorController.m
//  TicketingHub
//
//  Created by Mark Brindle on 10/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHDoorDateController.h"
#import "TXHDoorDateCell.h"
#import "TXHCommonNames.h"

@interface TXHDoorDateController () <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *dates;

@end

@implementation TXHDoorDateController

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
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(notifyDateSelected:)
                                               name:doorDateSelected
                                             object:nil];
  [self populateDatesArray];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (NSArray *)eventDates {
  return self.dates;
}

#pragma mark - Prototyping data

- (void)populateDatesArray {
  self.dates = [NSMutableArray array];
  NSTimeInterval interval;
  for (int i = 0; i < 14; i++) {
     interval = i * 24 * 60 * 60;
    NSDate *cellDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:cellDate];
    [self.dates addObject:[[NSCalendar currentCalendar] dateFromComponents:comps]];
  }
}

#pragma mark - Collection View DataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#pragma unused (collectionView)
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#pragma unused (collectionView, section)
  return self.dates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *cellID = @"dateCellID";
  
  TXHDoorDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
  
  [self configureDateCell:cell forIndexPath:indexPath];
  
  return cell;
}

#pragma mark - Collection View Delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  TXHDoorDateCell *cell = (TXHDoorDateCell *)[collectionView cellForItemAtIndexPath:indexPath];
  [[NSNotificationCenter defaultCenter] postNotificationName:doorDateCellSelected object:cell.date];
}

#pragma mark - Cell configuration

- (void)configureDateCell:(TXHDoorDateCell *)cell forIndexPath:(NSIndexPath *)indexPath {
  cell.date = [self.dates objectAtIndex:indexPath.row];
}

#pragma mark - Notifications

- (void)notifyDateSelected:(NSNotification *)notification {
  NSDate *dateSelected = [notification object];
  NSUInteger row = 0;
  for (NSDate *date in self.dates) {
    NSTimeInterval interval = [date timeIntervalSinceDate:dateSelected];
    if (interval > 0) {
      break;
    } else {
      row++;
    }
  }
  row = MIN(row, self.dates.count - 1);
  if (row > 0) {
    row--;
  }
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
  UICollectionView *cv = self.collectionView;
  [cv scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
  TXHDoorDateCell *cell = (TXHDoorDateCell *)[self collectionView:cv cellForItemAtIndexPath:indexPath];
  [[NSNotificationCenter defaultCenter] postNotificationName:doorDateCellSelected object:cell.date];
  [cv selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

@end
