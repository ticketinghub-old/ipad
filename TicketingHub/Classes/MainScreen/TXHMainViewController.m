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
#import "TXHEmbeddingSegue.h"
#import "TXHTransitionSegue.h"
#import "TXHDateSelectorViewController.h"

// UIAlertViewDelegate is ONLY FOR TESTING purposes & may be removed
@interface TXHMainViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;

@property (strong, nonatomic) TXHVenue *venue;
@property (strong, nonatomic) UIBarButtonItem *dateButton;
@property (strong, nonatomic) UIBarButtonItem *timeButton;
@property (strong, nonatomic) TXHDateSelectorViewController *dateViewController;
@property (strong, nonatomic) UIPopoverController *datePopover;

@property (assign, nonatomic) BOOL dateSelected;

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
    
    NSString *titleString = @"<Date>";
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
    
    self.dateButton = [[UIBarButtonItem alloc] initWithCustomView:dateBtn];
    
    titleString = @"<Time>";
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
    
    self.timeButton = [[UIBarButtonItem alloc] initWithCustomView:timeBtn];
    [self.navigationItem setLeftBarButtonItems:@[self.navigationItem.leftBarButtonItem, self.dateButton, self.timeButton]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSegueWithIdentifier:@"Embed Placeholder" sender:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateControlsForUserInteraction];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleMenu:(id)sender {
#pragma unused (sender)
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOGGLE_MENU object:nil];
}

-(void)selectDate:(id)sender {
#pragma unused (sender)
    self.dateSelected = YES;
    if (self.dateViewController == nil) {
        self.dateViewController = [[TXHDateSelectorViewController alloc] init];
    }
//    if (self.datePopover == nil) {
//        self.datePopover = [[UIPopoverController alloc] initWithContentViewController:self.dateViewController];
//    }
//    //Set popover configurations
    [self.dateViewController presentPopoverFromBarButtonItem:self.dateButton];
    [self updateControlsForUserInteraction];
}

-(void)selectTime:(id)sender {
#pragma unused (sender)
    NSLog(@"Time selected");
}

- (IBAction)selectMode:(id)sender {
#pragma unused (sender)
    if (self.modeSelector.selectedSegmentIndex == 1) {
        [self performSegueWithIdentifier:@"Flip to Doorman" sender:self];
    } else {
        [self performSegueWithIdentifier:@"Flip to Salesman" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#pragma unused (sender)
    if ([segue isMemberOfClass:[TXHEmbeddingSegue class]])
    {
        TXHEmbeddingSegue *embeddingSegue = (TXHEmbeddingSegue *) segue;
        
        embeddingSegue.containerView = self.view;
        
        return;
    }
    
    if ([segue isMemberOfClass:[TXHTransitionSegue class]]) {
        TXHTransitionSegue *transitionSegue = (TXHTransitionSegue *)segue;
        
        transitionSegue.containerView = self.view;

        if ([segue.identifier isEqualToString:@"Flip To Salesman"]) {
            transitionSegue.animationOptions = UIViewAnimationOptionTransitionCurlDown;
        }
        else
        {
            transitionSegue.animationOptions = UIViewAnimationOptionTransitionCurlUp;
        }
    }
}

- (void)updateControlsForUserInteraction {
    BOOL enabled = (self.venue != nil);
    self.modeSelector.userInteractionEnabled = enabled;
    self.dateButton.enabled = enabled;
    self.timeButton.enabled = (enabled && self.dateSelected);
}


#pragma mark - Notifications

- (void)venueSelected:(NSNotification *)notification {
    // Check for venue details then close menu if appropriate
    self.venue = [notification object];
    if (self.venue != nil) {
        self.title = self.venue.businessName;
    }
    self.dateSelected = NO;
    [self updateControlsForUserInteraction];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TOGGLE_MENU object:nil];
}

@end
