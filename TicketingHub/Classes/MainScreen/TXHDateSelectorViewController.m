//
//  TXHDateSelectorViewController.m
//  TicketingHub
//
//  Created by Mark on 22/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHDateSelectorViewController.h"

@interface TXHDateSelectorViewController ()

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation TXHDateSelectorViewController

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

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        self.datePicker = [[UIDatePicker alloc] init];
//        [self.view addSubview:self.datePicker];
//        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
//        self.selectButton = [[UIButton alloc] initWithFrame:CGRectMake(123.0f, 220.0f, 74.0f, 44.0f)];
//        [self.selectButton setTitle:NSLocalizedString(@"Select", @"Select") forState:UIControlStateNormal];
//        [self.selectButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [self.selectButton addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:self.selectButton];
//        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self];
//    }
//    return self;
//}
//
- (CGSize)contentSizeForViewInPopover
{
    return CGSizeMake(self.datePicker.bounds.size.width, self.datePicker.bounds.size.height + 54.0f);
}

- (void)constrainToDateRanges:(NSArray *)ranges {
    
}

- (IBAction)selectDate:(id)sender {
#pragma unused (sender)
    [self.delegate dateSelectorViewController:self didSelectDate:self.datePicker.date];
}

@end
