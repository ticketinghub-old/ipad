//
//  RKMCalendarView.h
//  Timecards
//
//  Created by Mark Brindle on 02/12/2011.
//  Copyright (c) 2011 ARKEMM Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RKMCalendarViewDelegate <NSObject>
@optional
- (BOOL)hasContentForDate:(NSDate *)date;
- (BOOL)willSelectDate:(NSDate *)date;
- (void)didSelectDate:(NSDate *)date;

@end

@interface RKMCalendarView : UIView {
  
}

@property (weak, nonatomic) IBOutlet id <RKMCalendarViewDelegate> delegate;
@property (strong, nonatomic) NSDate *currentDate;

- (void)selectDate:(NSDate *)date;

@end
