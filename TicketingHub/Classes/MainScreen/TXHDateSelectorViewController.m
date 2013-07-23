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

@property (strong, nonatomic) UIPopoverController *popoverController;

@end

@implementation TXHDateSelectorViewController

@synthesize popoverController;

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

- (id)init
{
    self = [super init];
    if (self) {
        self.datePicker = [[UIDatePicker alloc] init];
        [self.view addSubview:self.datePicker];
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self];
    }
    return self;
}

- (CGSize)contentSizeForViewInPopover
{
    return self.datePicker.bounds.size;
}

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view
{
    [self.popoverController presentPopoverFromRect:rect inView:view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item
{
    [self.popoverController presentPopoverFromBarButtonItem:item permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (BOOL)isPopoverVisible
{
    return self.popoverController.isPopoverVisible;
}

- (void)dismissPopover
{
    [self.popoverController dismissPopoverAnimated:YES];
}
@end
