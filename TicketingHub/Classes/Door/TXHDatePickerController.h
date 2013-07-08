//
//  TXHDatePickerController.h
//  TicketingHub
//
//  Created by Mark on 18/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXHDatePickerController : UIViewController

@property (strong, nonatomic) IBOutlet  UIDatePicker  *datePicker;
@property (weak, nonatomic)             NSArray       *availableDates;

@end
