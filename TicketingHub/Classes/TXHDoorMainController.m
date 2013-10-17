//
//  TXHDoorMainController.m
//  TicketingHub
//
//  Created by Mark on 18/06/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHDoorMainController.h"
#import "TXHDoorDateController.h"
#import "TXHCommonNames.h"

@interface TXHDoorMainController () <UIPickerViewDelegate>

@property (nonatomic, weak) TXHDoorDateController *doorDateController;
@end

@implementation TXHDoorMainController

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
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(venueSelected:) name:NOTIFICATION_VENUE_UPDATED object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
  if ([segue.identifier isEqualToString:@"doorDateSegue"]) {
    self.doorDateController = segue.destinationViewController;
    return;
  }
}

- (IBAction)showToday:(id)sender {
#pragma unused (sender)
  // When there's a model - update it & let the model handle notifications
  NSDate *now = [NSDate date];
  [[NSNotificationCenter defaultCenter] postNotificationName:doorDateSelected object:now];
}

- (void)venueSelected:(NSNotification *)notification {
#pragma unused (notification)
//  [[NSNotificationCenter defaultCenter] postNotificationName:TOGGLE_MENU object:nil];
}

@end
